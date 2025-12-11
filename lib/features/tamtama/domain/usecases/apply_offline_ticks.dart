import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/tamtama_entity.dart';
import '../repositories/tamtama_repository.dart';

class ApplyOfflineTicks
    extends UseCase<TamtamaEntity, ApplyOfflineTicksParams> {
  final TamtamaRepository repository;

  ApplyOfflineTicks(this.repository);

  @override
  Future<Either<Failure, TamtamaEntity>> call(ApplyOfflineTicksParams params) {
    return repository.applyOfflineTicks(params.userId);
  }
}

class ApplyOfflineTicksParams {
  final String userId;

  const ApplyOfflineTicksParams(this.userId);
}
