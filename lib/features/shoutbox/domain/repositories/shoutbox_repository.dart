import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/shoutbox_message_entity.dart';

abstract class ShoutboxRepository {
  Future<Either<Failure, List<ShoutboxMessageEntity>>> getMessages({
    int afterId = 0,
    int limit = 50,
  });
  Future<Either<Failure, ShoutboxMessageEntity>> sendMessage({
    required String username,
    required String message,
  });
  Future<Either<Failure, Unit>> deleteMessage(int id);
}

