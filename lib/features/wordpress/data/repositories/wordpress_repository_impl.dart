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
  Future<Either<Failure, List<PostEntity>>> getPosts() async {
    final cachedPosts = await localDataSource.getCachedPosts();
    
    if (cachedPosts != null && cachedPosts.isNotEmpty) {
      _fetchAndUpdateCacheInBackground();
      return Right(cachedPosts);
    }

    try {
      final posts = await remoteDataSource.getPosts();
      await localDataSource.cachePosts(posts);
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

  void _fetchAndUpdateCacheInBackground() async {
    try {
      final posts = await remoteDataSource.getPosts();
      await localDataSource.cachePosts(posts);
    } catch (e) {
      // Silently fail background cache update - cached data already returned
    }
  }
}

