import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/tamtama_entity.dart';
import '../repositories/tamtama_repository.dart';

class GetTamtama extends UseCase<TamtamaEntity, GetTamtamaParams> {
  final TamtamaRepository repository;

  GetTamtama(this.repository);

  @override
  Future<Either<Failure, TamtamaEntity>> call(GetTamtamaParams params) {
    return repository.fetch(params.userId);
  }
}

class GetTamtamaParams {
  final String userId;

  const GetTamtamaParams(this.userId);
}
