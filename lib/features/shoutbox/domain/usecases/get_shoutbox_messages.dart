import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/shoutbox_message_entity.dart';
import '../repositories/shoutbox_repository.dart';

class GetShoutboxMessages {
  final ShoutboxRepository repository;

  GetShoutboxMessages(this.repository);

  Future<Either<Failure, List<ShoutboxMessageEntity>>> call({
    int afterId = 0,
    int limit = 50,
  }) async {
    return await repository.getMessages(afterId: afterId, limit: limit);
  }
}

