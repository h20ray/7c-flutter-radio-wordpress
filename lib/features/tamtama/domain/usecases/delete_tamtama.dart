import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/tamtama_repository.dart';

class DeleteTamtama extends UseCase<void, DeleteTamtamaParams> {
  final TamtamaRepository repository;

  DeleteTamtama(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteTamtamaParams params) {
    return repository.delete(params.userId);
  }
}

class DeleteTamtamaParams {
  final String userId;

  const DeleteTamtamaParams(this.userId);
}
