import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/post_entity.dart';

abstract class WordPressRepository {
  Future<Either<Failure, List<PostEntity>>> getPosts({
    bool forceRefresh = false,
    int? categoryId,
    int page = 1,
    String? search,
    bool useNewsPageLimit = false,
  });
  Future<List<PostEntity>?> getCachedPosts({
    int? categoryId,
    int page = 1,
    String? search,
  });
  Future<DateTime?> getCacheTimestamp({
    int? categoryId,
    int page = 1,
    String? search,
  });
  Future<Either<Failure, Unit>> savePostOffline(PostEntity post);
  Future<Either<Failure, Unit>> removePostOffline(int postId);
  Future<Either<Failure, List<PostEntity>>> getOfflinePosts();
  Future<Either<Failure, bool>> isPostOffline(int postId);
}
