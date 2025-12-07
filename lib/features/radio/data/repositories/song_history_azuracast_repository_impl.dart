import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/song_history_entity.dart';
import '../../domain/repositories/song_history_repository.dart';
import '../datasources/song_history_azuracast_data_source.dart';
import '../datasources/song_history_local_data_source.dart';
import '../models/song_history_model.dart';
import '../../presentation/bloc/radio_bloc.dart';

class SongHistoryAzuracastRepositoryImpl implements SongHistoryRepository {
  final SongHistoryAzuracastDataSource azuracastDataSource;
  final SongHistoryLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  SongHistoryAzuracastRepositoryImpl({
    required this.azuracastDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  String? _getStreamUrl() {
    try {
      final radioBloc = GetIt.instance<RadioBloc>();
      final radioState = radioBloc.state;
      
      String? streamUrl;
      radioState.maybeWhen(
        loaded: (radioEntity) {
          streamUrl = radioEntity.streamUrl;
        },
        orElse: () {},
      );
      
      return streamUrl;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Either<Failure, List<SongHistoryEntity>>> getSongHistory({
    int limit = 100,
  }) async {
    final streamUrl = _getStreamUrl();
    
    if (streamUrl == null || streamUrl.isEmpty) {
      return const Left(ServerFailure(
        'Stream URL not available. Please ensure radio is initialized.',
      ));
    }

    final isOnline = await networkInfo.isConnected;

    // Always try to get cached data first (for offline support)
    List<SongHistoryModel> cachedSongs = [];
    try {
      cachedSongs = await localDataSource.getSongHistory(limit: limit);
    } catch (e) {
      // Ignore cache errors, continue with API fetch
    }

    // If offline, return cached data
    if (!isOnline) {
      return Right(cachedSongs);
    }

    // Online: Fetch from API and merge with cache
    try {
      final apiSongs = await azuracastDataSource.getSongHistory(
        streamUrl: streamUrl,
        limit: limit,
      );

      // Smart merge: Combine API and cache, remove duplicates, keep newest
      final mergedSongs = _mergeSongHistory(apiSongs, cachedSongs);

      // Store merged result back to cache
      await _updateCache(mergedSongs);

      // Return merged and limited result
      final limitedSongs = mergedSongs.take(limit).toList();
      return Right(limitedSongs);
    } on ServerException catch (e) {
      // If API fails but we have cache, return cache
      if (cachedSongs.isNotEmpty) {
        return Right(cachedSongs);
      }
      return Left(ServerFailure(e.message));
    } catch (error) {
      // If API fails but we have cache, return cache
      if (cachedSongs.isNotEmpty) {
        return Right(cachedSongs);
      }
      return Left(UnknownFailure(error.toString()));
    }
  }

  /// Smart merge: Combine API songs with cached songs, removing duplicates
  /// Keeps the newest version of each song (by timestamp)
  List<SongHistoryModel> _mergeSongHistory(
    List<SongHistoryModel> apiSongs,
    List<SongHistoryModel> cachedSongs,
  ) {
    final Map<String, SongHistoryModel> songMap = {};

    // Add cached songs first (older data)
    for (final song in cachedSongs) {
      final key = _getSongKey(song.artist, song.title);
      songMap[key] = song;
    }

    // Add/update with API songs (newer data takes precedence)
    for (final song in apiSongs) {
      final key = _getSongKey(song.artist, song.title);
      final existing = songMap[key];

      if (existing == null) {
        // New song, add it
        songMap[key] = song;
      } else {
        // Duplicate found, keep the one with newer timestamp
        if (song.timestamp.isAfter(existing.timestamp)) {
          songMap[key] = song;
        } else {
          // Keep existing but update album art if missing
          if (song.albumArtUrl != null && existing.albumArtUrl == null) {
            songMap[key] = SongHistoryModel(
              id: existing.id,
              artist: existing.artist,
              title: existing.title,
              timestamp: existing.timestamp,
              albumArtUrl: song.albumArtUrl,
            );
          }
        }
      }
    }

    // Convert to list and sort by timestamp (newest first)
    final merged = songMap.values.toList();
    merged.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return merged;
  }

  /// Generate a unique key for a song (for duplicate detection)
  String _getSongKey(String artist, String title) {
    return '${artist.toLowerCase().trim()}_${title.toLowerCase().trim()}';
  }

  /// Update cache with merged songs
  Future<void> _updateCache(List<SongHistoryModel> songs) async {
    try {
      // Clear existing cache
      await localDataSource.clearHistory();

      // Add all merged songs to cache (in reverse order so newest is first)
      for (final song in songs.reversed) {
        await localDataSource.addSong(song);
      }
    } catch (e) {
      // Ignore cache update errors
    }
  }

  @override
  Future<Either<Failure, SongHistoryEntity>> addSong({
    required String artist,
    required String title,
    String? albumArtUrl,
  }) async {
    return const Left(UnsupportedFailure(
      'Adding songs is not supported in Azuracast mode. Songs are fetched from the Azuracast API.',
    ));
  }

  @override
  Future<Either<Failure, Unit>> syncToWordPress() async {
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> clearHistory() async {
    try {
      // Clear local cache only (API history is managed by Azuracast)
      await localDataSource.clearHistory();
      return const Right(unit);
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
    return const Right(unit);
  }
}

