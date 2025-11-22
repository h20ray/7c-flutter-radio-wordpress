import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/radio_player_repository.dart';

/// Use case for starting radio playback
class PlayRadio {
  final RadioPlayerRepository repository;

  PlayRadio(this.repository);

  /// Start radio playback
  Future<Either<Failure, Unit>> call() async {
    return await repository.play();
  }
}

