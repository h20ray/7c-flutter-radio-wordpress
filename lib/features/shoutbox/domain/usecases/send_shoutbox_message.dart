import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/shoutbox_message_entity.dart';
import '../repositories/shoutbox_repository.dart';

class SendShoutboxMessage {
  final ShoutboxRepository repository;

  SendShoutboxMessage(this.repository);

  Future<Either<Failure, ShoutboxMessageEntity>> call({
    required String username,
    required String message,
  }) async {
    return await repository.sendMessage(username: username, message: message);
  }
}

