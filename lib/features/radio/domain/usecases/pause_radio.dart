import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/radio_player_repository.dart';

/// Use case for pausing radio playback
class PauseRadio {
  final RadioPlayerRepository repository;

  PauseRadio(this.repository);

  /// Pause radio playback
  Future<Either<Failure, Unit>> call() async {
    return await repository.pause();
  }
}

