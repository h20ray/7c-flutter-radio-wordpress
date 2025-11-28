import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/post_entity.dart';
import '../repositories/wordpress_repository.dart';

class GetPosts {
  final WordPressRepository repository;

  GetPosts(this.repository);

  Future<Either<Failure, List<PostEntity>>> call({
    bool forceRefresh = false,
    int? categoryId,
  }) async {
    return repository.getPosts(forceRefresh: forceRefresh, categoryId: categoryId);
  }

  Future<List<PostEntity>?> getCachedPosts({int? categoryId}) async {
    return repository.getCachedPosts(categoryId: categoryId);
  }

  Future<DateTime?> getCacheTimestamp({int? categoryId}) async {
    return repository.getCacheTimestamp(categoryId: categoryId);
  }
}
