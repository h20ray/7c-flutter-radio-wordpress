import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/lyrics_entity.dart';

abstract class LyricsRepository {
  Future<Either<Failure, LyricsEntity>> getLyrics({
    required String artist,
    required String title,
  });
}

