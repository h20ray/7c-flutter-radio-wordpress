import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/shoutbox_repository.dart';

class DeleteShoutboxMessage {
  final ShoutboxRepository repository;

  DeleteShoutboxMessage(this.repository);

  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.deleteMessage(id);
  }
}

