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
    int page = 1,
    String? search,
    bool useNewsPageLimit = false,
  }) async {
    return repository.getPosts(
      forceRefresh: forceRefresh,
      categoryId: categoryId,
      page: page,
      search: search,
      useNewsPageLimit: useNewsPageLimit,
    );
  }

  Future<List<PostEntity>?> getCachedPosts({
    int? categoryId,
    int page = 1,
    String? search,
  }) async {
    return repository.getCachedPosts(
      categoryId: categoryId,
      page: page,
      search: search,
    );
  }

  Future<DateTime?> getCacheTimestamp({
    int? categoryId,
    int page = 1,
    String? search,
  }) async {
    return repository.getCacheTimestamp(
      categoryId: categoryId,
      page: page,
      search: search,
    );
  }
}
