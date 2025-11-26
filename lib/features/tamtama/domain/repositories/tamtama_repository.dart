import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/tamtama_entity.dart';

abstract class TamtamaRepository {
  Future<Either<Failure, TamtamaEntity>> fetch(String userId);
  Future<Either<Failure, TamtamaEntity>> save(TamtamaEntity tamtama);
  Stream<Either<Failure, TamtamaEntity>> watch(String userId);
}

