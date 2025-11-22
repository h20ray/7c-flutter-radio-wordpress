import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/shoutbox_message_entity.dart';
import '../../domain/repositories/shoutbox_repository.dart';
import '../datasources/shoutbox_remote_datasource.dart';

class ShoutboxRepositoryImpl implements ShoutboxRepository {
  final ShoutboxRemoteDataSource remoteDataSource;

  ShoutboxRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ShoutboxMessageEntity>>> getMessages({
    int afterId = 0,
    int limit = 50,
  }) async {
    try {
      final messages = await remoteDataSource.getMessages(
        afterId: afterId,
        limit: limit,
      );
      return Right(messages);
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

  @override
  Future<Either<Failure, ShoutboxMessageEntity>> sendMessage({
    required String username,
    required String message,
  }) async {
    try {
      final messageEntity = await remoteDataSource.sendMessage(
        username: username,
        message: message,
      );
      return Right(messageEntity);
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

  @override
  Future<Either<Failure, Unit>> deleteMessage(int id) async {
    try {
      await remoteDataSource.deleteMessage(id);
      return const Right(unit);
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

