import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/tamtama_economy_entity.dart';
import '../repositories/tamtama_repository.dart';

class GetEconomy extends UseCase<TamtamaEconomyEntity, GetEconomyParams> {
  final TamtamaRepository repository;

  GetEconomy(this.repository);

  @override
  Future<Either<Failure, TamtamaEconomyEntity>> call(GetEconomyParams params) {
    return repository.getEconomy(params.userId);
  }
}

class GetEconomyParams {
  final String userId;

  const GetEconomyParams(this.userId);
}
