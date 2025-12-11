import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/tamtama_entity.dart';
import '../repositories/tamtama_repository.dart';

class WatchTamtama {
  final TamtamaRepository repository;

  WatchTamtama(this.repository);

  Stream<Either<Failure, TamtamaEntity>> call(String userId) {
    return repository.watch(userId);
  }
}
