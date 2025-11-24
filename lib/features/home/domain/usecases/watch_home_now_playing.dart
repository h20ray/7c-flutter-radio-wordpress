import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/now_playing_entity.dart';
import '../repositories/home_radio_repository.dart';

class WatchHomeNowPlaying {
  final HomeRadioRepository repository;

  const WatchHomeNowPlaying(this.repository);

  Stream<Either<Failure, NowPlayingEntity>> call() {
    return repository.watchNowPlaying();
  }
}
