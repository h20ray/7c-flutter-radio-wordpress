import 'package:dartz/dartz.dart';
import '../../../../config/news_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/wordpress_repository.dart';
import '../datasources/wordpress_remote_datasource.dart';
import '../datasources/wordpress_local_data_source.dart';
import '../services/offline_news_service.dart';
import '../models/post_model.dart';

class WordPressRepositoryImpl implements WordPressRepository {
  final WordPressRemoteDataSource remoteDataSource;
  final WordPressLocalDataSource localDataSource;
  final OfflineNewsService offlineNewsService;

  WordPressRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.offlineNewsService,
  });

  @override
  Future<List<PostEntity>?> getCachedPosts({
    int? categoryId,
    int page = 1,
    String? search,
  }) async {
    final cachedPosts = await localDataSource.getCachedPosts(
      categoryId: categoryId,
      page: page,
      search: search,
    );
    if (cachedPosts != null && cachedPosts.isNotEmpty) {
      return cachedPosts;
    }
    return null;
  }

  @override
  Future<DateTime?> getCacheTimestamp({
    int? categoryId,
    int page = 1,
    String? search,
  }) async {
    return localDataSource.getCacheTimestamp(
      categoryId: categoryId,
      page: page,
      search: search,
    );
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts({
    bool forceRefresh = false,
    int? categoryId,
    int page = 1,
    String? search,
    bool useNewsPageLimit = false,
  }) async {
    // 1. If not forcing refresh, try to get from cache first
    if (!forceRefresh) {
      final cachedPosts = await localDataSource.getCachedPosts(
        categoryId: categoryId,
        page: page,
        search: search,
      );

      if (cachedPosts != null && cachedPosts.isNotEmpty) {
        return Right(cachedPosts);
      }
    }

    // 2. Fetch from network
    try {
      final perPage = search != null && search.isNotEmpty
          ? NewsConfig.newsPageListLimit
          : (useNewsPageLimit || page > 1
              ? NewsConfig.newsPageListLimit
              : NewsConfig.homeNewsListLimit);
      
      final posts = await remoteDataSource.getPosts(
        categoryId: categoryId,
        page: page,
        perPage: perPage,
        search: search,
      );

      final enrichedPosts = await _enrichPosts(posts);
      
      // 3. Save to cache (only for first page or search results)
      if (page == 1 || search != null) {
        await localDataSource.cachePosts(
          enrichedPosts,
          categoryId: categoryId,
          page: page,
          search: search,
        );
      }
      
      return Right(enrichedPosts.cast<PostEntity>());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on TimeoutException catch (e) {
      return Left(TimeoutFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<List<PostModel>> _enrichPosts(List<PostModel> posts) async {
    if (!NewsConfig.useMinimalNewsPayload) {
      return posts;
    }

    final mediaIds = <int>[];
    final categoryIds = <int>[];
    final authorIds = <int>[];

    for (final post in posts) {
      if (post.featuredMediaId != null && post.featuredMediaId! > 0) {
        mediaIds.add(post.featuredMediaId!);
      }
      for (final id in post.categoryIds) {
        if (id > 0) {
          categoryIds.add(id);
        }
      }
      if (post.authorId != null && post.authorId! > 0) {
        authorIds.add(post.authorId!);
      }
    }

    final Map<int, String> resolvedMedia = {};
    final Map<int, String> resolvedCategories = {};
    final Map<int, String> resolvedUsers = {};

    if (mediaIds.isNotEmpty) {
      resolvedMedia.addAll(await remoteDataSource.getMediaByIds(mediaIds));
    }

    if (categoryIds.isNotEmpty) {
      resolvedCategories.addAll(
          await remoteDataSource.getCategoriesByIds(categoryIds));
    }

    if (authorIds.isNotEmpty) {
      resolvedUsers.addAll(await remoteDataSource.getUsersByIds(authorIds));
    }

    return posts
        .map(
          (post) => PostModel(
            id: post.id,
            title: post.title,
            content: post.content,
            excerpt: post.excerpt,
            link: post.link,
            featuredImageUrl: post.featuredMediaId != null
                ? resolvedMedia[post.featuredMediaId] ?? post.featuredImageUrl
                : post.featuredImageUrl,
            date: post.date,
            categoryName: post.categoryIds.isNotEmpty
                ? resolvedCategories[post.categoryIds.first] ??
                    post.categoryName
                : post.categoryName,
            categoryIds: post.categoryIds,
            featuredMediaId: post.featuredMediaId,
            authorId: post.authorId,
            authorName: post.authorId != null
                ? resolvedUsers[post.authorId] ?? post.authorName
                : post.authorName,
          ),
        )
        .toList();
  }

  @override
  Future<Either<Failure, Unit>> savePostOffline(PostEntity post) async {
    try {
      final postModel = PostModel(
        id: post.id,
        title: post.title,
        content: post.content,
        excerpt: post.excerpt,
        link: post.link,
        featuredImageUrl: post.featuredImageUrl,
        date: post.date,
        categoryName: post.categoryName,
        categoryIds: post.categoryIds,
        authorName: post.authorName,
      );
      await offlineNewsService.savePost(postModel);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure('Failed to save post offline: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> removePostOffline(int postId) async {
    try {
      await offlineNewsService.removePost(postId);
      return const Right(unit);
    } catch (e) {
      return Left(
          CacheFailure('Failed to remove post from offline: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getOfflinePosts() async {
    try {
      final posts = await offlineNewsService.getAllPosts();
      return Right(posts.cast<PostEntity>());
    } catch (e) {
      return Left(
          CacheFailure('Failed to get offline posts: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> isPostOffline(int postId) async {
    try {
      final isOffline = await offlineNewsService.isPostOffline(postId);
      return Right(isOffline);
    } catch (e) {
      return Left(
          CacheFailure('Failed to check if post is offline: ${e.toString()}'));
    }
  }
}
