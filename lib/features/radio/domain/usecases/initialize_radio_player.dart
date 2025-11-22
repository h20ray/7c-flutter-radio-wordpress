import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/radio_entity.dart';
import '../repositories/radio_player_repository.dart';

/// Use case for initializing the radio player with configuration
class InitializeRadioPlayer {
  final RadioPlayerRepository repository;

  InitializeRadioPlayer(this.repository);

  /// Initialize the radio player with the given configuration
  Future<Either<Failure, Unit>> call(RadioEntity config) async {
    return await repository.initialize(config);
  }
}

