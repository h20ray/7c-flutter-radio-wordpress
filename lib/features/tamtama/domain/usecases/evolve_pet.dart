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

    return petResult.fold(
      (failure) => Left(failure),
      (pet) async {
        if (!evolutionService.shouldEvolve(pet)) {
          // If not ready, return current pet without changes
          // Or we could return a specific failure if we wanted to enforce it
          return Right(pet);
        }

        final evolvedPet = evolutionService.evolve(pet);
        return await repository.save(evolvedPet);
      },
    );
  }
}

class EvolvePetParams {
  final String userId;

  const EvolvePetParams({required this.userId});
}
