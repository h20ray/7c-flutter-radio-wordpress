import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/tamtama_economy_entity.dart';
import '../repositories/tamtama_repository.dart';

class WatchEconomy {
  final TamtamaRepository repository;

  WatchEconomy(this.repository);

  Stream<Either<Failure, TamtamaEconomyEntity>> call(String userId) {
    return repository.watchEconomy(userId);
  }
}
