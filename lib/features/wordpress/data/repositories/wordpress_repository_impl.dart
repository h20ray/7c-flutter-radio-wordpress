import 'package:dartz/dartz.dart';
import '../../../../config/news_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/wordpress_repository.dart';
import '../datasources/wordpress_remote_datasource.dart';
import '../datasources/wordpress_local_data_source.dart';

class WordPressRepositoryImpl implements WordPressRepository {
  final WordPressRemoteDataSource remoteDataSource;
  final WordPressLocalDataSource localDataSource;

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
    final cachedPosts = await localDataSource.getCachedPosts(
      categoryId: categoryId,
      page: page,
      search: search,
    );

    if (!forceRefresh && cachedPosts != null && cachedPosts.isNotEmpty) {
      _fetchAndUpdateCacheInBackground(
        categoryId: categoryId,
        page: page,
        search: search,
        useNewsPageLimit: useNewsPageLimit,
      );
      return Right(cachedPosts);
    }

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
      
      if (page == 1 || search != null) {
        await localDataSource.cachePosts(
          posts,
          categoryId: categoryId,
          page: page,
          search: search,
        );
      }
      
      return Right(posts);
    } on ServerException catch (e) {
      if (cachedPosts != null && cachedPosts.isNotEmpty) {
        return Right(cachedPosts);
      }
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      if (cachedPosts != null && cachedPosts.isNotEmpty) {
        return Right(cachedPosts);
      }
      return Left(NetworkFailure(e.message));
    } on TimeoutException catch (e) {
      if (cachedPosts != null && cachedPosts.isNotEmpty) {
        return Right(cachedPosts);
      }
      return Left(TimeoutFailure(e.message));
    } catch (e) {
      if (cachedPosts != null && cachedPosts.isNotEmpty) {
        return Right(cachedPosts);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  void _fetchAndUpdateCacheInBackground({
    int? categoryId,
    int page = 1,
    String? search,
    bool useNewsPageLimit = false,
  }) async {
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
      
      if (page == 1 || search != null) {
        await localDataSource.cachePosts(
          posts,
          categoryId: categoryId,
          page: page,
          search: search,
        );
      }
    } catch (e) {
      // Silently fail background cache update - cached data already returned
    }
  }
}
