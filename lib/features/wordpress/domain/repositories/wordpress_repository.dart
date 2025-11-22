import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/post_entity.dart';

abstract class WordPressRepository {
  Future<Either<Failure, List<PostEntity>>> getPosts();
}

