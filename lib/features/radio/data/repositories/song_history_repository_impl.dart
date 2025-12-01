import 'package:dartz/dartz.dart';
import '../../../../config/radio_config.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/song_history_entity.dart';
import '../../domain/repositories/song_history_repository.dart';
import '../datasources/song_history_local_data_source.dart';
import '../datasources/song_history_remote_data_source.dart';
import '../models/song_history_model.dart';

class SongHistoryRepositoryImpl implements SongHistoryRepository {
  final SongHistoryLocalDataSource localDataSource;
  final SongHistoryRemoteDataSource? remoteDataSource;

  SongHistoryRepositoryImpl({
    required this.localDataSource,
    this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<SongHistoryEntity>>> getSongHistory({
    int limit = 100,
  }) async {
    try {
      final songs = await localDataSource.getSongHistory(limit: limit);
      return Right(songs);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, SongHistoryEntity>> addSong({
    required String artist,
    required String title,
    String? albumArtUrl,
  }) async {
    try {
      final timestamp = DateTime.now();
      final id = '${artist}_${title}_${timestamp.millisecondsSinceEpoch}';
      
      final song = SongHistoryModel(
        id: id,
        artist: artist,
        title: title,
        timestamp: timestamp,
        albumArtUrl: albumArtUrl,
      );

      await localDataSource.addSong(song);
      return Right(song);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateAlbumArt({
    required String artist,
    required String title,
    required String albumArtUrl,
  }) async {
    try {
      await localDataSource.updateAlbumArt(
        artist: artist,
        title: title,
        albumArtUrl: albumArtUrl,
      );
      return const Right(unit);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> syncToWordPress() async {
    if (!RadioConfig.songHistorySyncToWordPress || remoteDataSource == null) {
      return const Right(unit);
    }

    try {
      final songs = await localDataSource.getSongHistory();
      if (songs.isEmpty) {
        return const Right(unit);
      }

      await remoteDataSource!.syncSongHistory(songs);
      return const Right(unit);
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearHistory() async {
    try {
      await localDataSource.clearHistory();
      return const Right(unit);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }
}

