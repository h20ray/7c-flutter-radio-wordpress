import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/tamtama_entity.dart';
import '../repositories/tamtama_repository.dart';

class SetSleepMode extends UseCase<TamtamaEntity, SetSleepModeParams> {
  final TamtamaRepository repository;

  SetSleepMode(this.repository);

  @override
  Future<Either<Failure, TamtamaEntity>> call(SetSleepModeParams params) {
    return repository.setSleepMode(params.userId, params.sleeping);
  }
}

class SetSleepModeParams {
  final String userId;
  final bool sleeping;

  const SetSleepModeParams({
    required this.userId,
    required this.sleeping,
  });
}
