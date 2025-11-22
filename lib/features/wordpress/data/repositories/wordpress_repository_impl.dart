import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/wordpress_repository.dart';
import '../datasources/wordpress_remote_datasource.dart';

class WordPressRepositoryImpl implements WordPressRepository {
  final WordPressRemoteDataSource remoteDataSource;

  WordPressRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts() async {
    try {
      final posts = await remoteDataSource.getPosts();
      return Right(posts);
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
}

