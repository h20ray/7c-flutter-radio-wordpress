import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/tamtama_entity.dart';
import '../repositories/tamtama_repository.dart';

class ApplyTick extends UseCase<TamtamaEntity, ApplyTickParams> {
  final TamtamaRepository repository;

  ApplyTick(this.repository);

  @override
  Future<Either<Failure, TamtamaEntity>> call(ApplyTickParams params) {
    return repository.applyTick(
      params.userId,
      isListening: params.isListening,
      isSleeping: params.isSleeping,
    );
  }
}

class ApplyTickParams {
  final String userId;
  final bool isListening;
  final bool isSleeping;

  const ApplyTickParams({
    required this.userId,
    this.isListening = false,
    this.isSleeping = false,
  });
}
