import 'package:dartz/dartz.dart';
import '../../../../config/news_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/wordpress_repository.dart';
import '../datasources/wordpress_remote_datasource.dart';
import '../datasources/wordpress_local_data_source.dart';
import '../models/post_model.dart';

class WordPressRepositoryImpl implements WordPressRepository {
  final WordPressRemoteDataSource remoteDataSource;
  final WordPressLocalDataSource localDataSource;

  final Map<int, String> _mediaUrlCache = {};
  final Map<int, String> _categoryNameCache = {};
  final Map<int, String> _authorNameCache = {};

  WordPressRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
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
      if (post.featuredMediaId != null &&
          post.featuredMediaId! > 0 &&
          !_mediaUrlCache.containsKey(post.featuredMediaId)) {
        mediaIds.add(post.featuredMediaId!);
      }
      for (final id in post.categoryIds) {
        if (id > 0 && !_categoryNameCache.containsKey(id)) {
          categoryIds.add(id);
        }
      }
      if (post.authorId != null &&
          post.authorId! > 0 &&
          !_authorNameCache.containsKey(post.authorId)) {
        authorIds.add(post.authorId!);
      }
    }

    if (mediaIds.isNotEmpty) {
      final resolvedMedia = await remoteDataSource.getMediaByIds(mediaIds);
      _mediaUrlCache.addAll(resolvedMedia);
    }

    if (categoryIds.isNotEmpty) {
      final resolvedCategories =
          await remoteDataSource.getCategoriesByIds(categoryIds);
      _categoryNameCache.addAll(resolvedCategories);
    }

    if (authorIds.isNotEmpty) {
      final resolvedUsers = await remoteDataSource.getUsersByIds(authorIds);
      _authorNameCache.addAll(resolvedUsers);
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
                ? _mediaUrlCache[post.featuredMediaId] ?? post.featuredImageUrl
                : post.featuredImageUrl,
            date: post.date,
            categoryName: post.categoryIds.isNotEmpty
                ? _categoryNameCache[post.categoryIds.first] ??
                    post.categoryName
                : post.categoryName,
            categoryIds: post.categoryIds,
            featuredMediaId: post.featuredMediaId,
            authorId: post.authorId,
            authorName: post.authorId != null
                ? _authorNameCache[post.authorId] ?? post.authorName
                : post.authorName,
          ),
        )
        .toList();
  }
}
