import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/radio_entity.dart';

abstract class RadioRepository {
  Future<Either<Failure, RadioEntity>> getRadioConfig();
}

