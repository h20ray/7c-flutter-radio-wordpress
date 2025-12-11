import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/tamtama_entity.dart';
import '../repositories/tamtama_repository.dart';

class PlayWithPet extends UseCase<TamtamaEntity, PlayWithPetParams> {
  final TamtamaRepository repository;

  PlayWithPet(this.repository);

  @override
  Future<Either<Failure, TamtamaEntity>> call(PlayWithPetParams params) {
    return repository.playWithPet(params.userId, params.activity);
  }
}

class PlayWithPetParams {
  final String userId;
  final ActivityType activity;

  const PlayWithPetParams({
    required this.userId,
    required this.activity,
  });
}
