import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/tamtama_entity.dart';
import '../repositories/tamtama_repository.dart';

class FeedPet extends UseCase<TamtamaEntity, FeedPetParams> {
  final TamtamaRepository repository;

  FeedPet(this.repository);

  @override
  Future<Either<Failure, TamtamaEntity>> call(FeedPetParams params) {
    return repository.feedPet(params.userId, params.food);
  }
}

class FeedPetParams {
  final String userId;
  final FoodType food;

  const FeedPetParams({
    required this.userId,
    required this.food,
  });
}
