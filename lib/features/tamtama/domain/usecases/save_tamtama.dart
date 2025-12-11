import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/tamtama_entity.dart';
import '../repositories/tamtama_repository.dart';

class SaveTamtama extends UseCase<TamtamaEntity, SaveTamtamaParams> {
  final TamtamaRepository repository;

  SaveTamtama(this.repository);

  @override
  Future<Either<Failure, TamtamaEntity>> call(SaveTamtamaParams params) {
    return repository.save(params.tamtama);
  }
}

class SaveTamtamaParams {
  final TamtamaEntity tamtama;

  const SaveTamtamaParams(this.tamtama);
}
