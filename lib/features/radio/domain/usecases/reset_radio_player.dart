import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/radio_player_repository.dart';

/// Use case for resetting the radio player to initial state
class ResetRadioPlayer {
  final RadioPlayerRepository repository;

  ResetRadioPlayer(this.repository);

  /// Reset the radio player to initial state
  Future<Either<Failure, Unit>> call() async {
    return await repository.reset();
  }
}

