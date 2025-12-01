import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/song_history_entity.dart';

abstract class SongHistoryRepository {
  Future<Either<Failure, List<SongHistoryEntity>>> getSongHistory({
    int limit = 100,
  });

  Future<Either<Failure, SongHistoryEntity>> addSong({
    required String artist,
    required String title,
    String? albumArtUrl,
  });

  Future<Either<Failure, Unit>> syncToWordPress();

  Future<Either<Failure, Unit>> clearHistory();

  Future<Either<Failure, Unit>> updateAlbumArt({
    required String artist,
    required String title,
    required String albumArtUrl,
  });
}

