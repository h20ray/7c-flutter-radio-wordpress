import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/tamtama_economy_entity.dart';
import '../repositories/tamtama_repository.dart';

class AddListeningRewards
    extends UseCase<TamtamaEconomyEntity, AddListeningRewardsParams> {
  final TamtamaRepository repository;

  AddListeningRewards(this.repository);

  @override
  Future<Either<Failure, TamtamaEconomyEntity>> call(
      AddListeningRewardsParams params) {
    return repository.addListeningRewards(
      params.userId,
      params.minutes,
      params.stationId,
    );
  }
}

class AddListeningRewardsParams {
  final String userId;
  final int minutes;
  final String stationId;

  const AddListeningRewardsParams({
    required this.userId,
    required this.minutes,
    required this.stationId,
  });
}
