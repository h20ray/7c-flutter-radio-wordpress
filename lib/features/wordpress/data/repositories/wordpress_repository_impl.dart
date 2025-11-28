import 'package:dartz/dartz.dart';
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
  Future<List<PostEntity>?> getCachedPosts({int? categoryId}) async {
    final cachedPosts = await localDataSource.getCachedPosts(categoryId: categoryId);
    if (cachedPosts != null && cachedPosts.isNotEmpty) {
      return cachedPosts;
    }
    return null;
  }

  @override
  Future<DateTime?> getCacheTimestamp({int? categoryId}) async {
    return localDataSource.getCacheTimestamp(categoryId: categoryId);
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts({
    bool forceRefresh = false,
    int? categoryId,
  }) async {
    final cachedPosts = await localDataSource.getCachedPosts(categoryId: categoryId);

    if (!forceRefresh && cachedPosts != null && cachedPosts.isNotEmpty) {
      _fetchAndUpdateCacheInBackground(categoryId: categoryId);
      return Right(cachedPosts);
    }

    try {
      final posts = await remoteDataSource.getPosts(categoryId: categoryId);
      await localDataSource.cachePosts(posts, categoryId: categoryId);
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

  void _fetchAndUpdateCacheInBackground({int? categoryId}) async {
    try {
      final posts = await remoteDataSource.getPosts(categoryId: categoryId);
      await localDataSource.cachePosts(posts, categoryId: categoryId);
    } catch (e) {
      // Silently fail background cache update - cached data already returned
    }
  }
}
