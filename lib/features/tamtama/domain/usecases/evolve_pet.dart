import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/tamtama_entity.dart';
import '../repositories/tamtama_repository.dart';
import '../services/tamtama_evolution_service.dart';

class EvolvePet implements UseCase<TamtamaEntity, EvolvePetParams> {
  final TamtamaRepository repository;
  final TamtamaEvolutionService evolutionService;

  EvolvePet(this.repository, this.evolutionService);

  @override
  Future<Either<Failure, TamtamaEntity>> call(EvolvePetParams params) async {
    final petResult = await repository.fetch(params.userId);
    final economyResult = await repository.getEconomy(params.userId);

    return petResult.fold(
      (failure) => Left(failure),
      (pet) async {
        return economyResult.fold(
          (failure) => Left(failure),
          (economy) async {
            final hasListeningRequirement =
                pet.lifeStage != LifeStage.egg || economy.totalListeningMinutes >= 60;

            if (!hasListeningRequirement) {
              return const Left(
                ValidationFailure('Listen to radio for 60 minutes to hatch'),
              );
            }

            if (!evolutionService.shouldEvolve(pet)) {
              return Right(pet);
            }

            final evolvedPet = evolutionService
                .evolve(pet)
                .copyWith(lastUpdateAt: DateTime.now());

            return await repository.save(evolvedPet);
          },
        );
      },
    );
  }
}

class EvolvePetParams {
  final String userId;

  const EvolvePetParams({required this.userId});
}
