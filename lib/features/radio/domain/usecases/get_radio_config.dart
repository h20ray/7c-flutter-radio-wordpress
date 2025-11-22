import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/radio_entity.dart';
import '../repositories/radio_repository.dart';

class GetRadioConfig {
  final RadioRepository repository;

  GetRadioConfig(this.repository);

  Future<Either<Failure, RadioEntity>> call() async {
    return await repository.getRadioConfig();
  }
}

