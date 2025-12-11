import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/tamtama_entity.dart';
import '../repositories/tamtama_repository.dart';

class CleanPet extends UseCase<TamtamaEntity, CleanPetParams> {
  final TamtamaRepository repository;

  CleanPet(this.repository);

  @override
  Future<Either<Failure, TamtamaEntity>> call(CleanPetParams params) {
    return repository.cleanPet(params.userId);
  }
}

class CleanPetParams {
  final String userId;

  const CleanPetParams(this.userId);
}
