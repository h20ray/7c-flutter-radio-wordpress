import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/now_playing_entity.dart';

abstract class HomeRadioRepository {
  Stream<Either<Failure, NowPlayingEntity>> watchNowPlaying();
}
