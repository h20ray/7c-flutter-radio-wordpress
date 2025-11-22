import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/post_entity.dart';
import '../repositories/wordpress_repository.dart';

class GetPosts {
  final WordPressRepository repository;

  GetPosts(this.repository);

  Future<Either<Failure, List<PostEntity>>> call() async {
    return await repository.getPosts();
  }
}

