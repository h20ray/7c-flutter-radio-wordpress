import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/lyrics_entity.dart';
import '../../domain/repositories/lyrics_repository.dart';
import '../datasources/lyrics_local_data_source.dart';
import '../datasources/lyrics_remote_data_source.dart';

class LyricsRepositoryImpl implements LyricsRepository {
  final LyricsLocalDataSource localDataSource;
  final LyricsRemoteDataSource remoteDataSource;

  LyricsRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, LyricsEntity>> getLyrics({
    required String artist,
    required String title,
  }) async {
    // Check cache first (matches WordPress plugin behavior)
    try {
      final cached = await localDataSource.getCachedLyrics(artist, title);
      if (cached != null && cached.lyrics.trim().isNotEmpty) {
        return Right(cached);
      }
    } catch (e) {
      // Cache error, continue to fetch from API
    }

    // Fetch from remote source (handles fallback chain internally)
    try {
      final lyrics = await remoteDataSource.getLyrics(artist, title);
      
      // Cache the result (best-effort, don't fail if cache fails)
      try {
        await localDataSource.cacheLyrics(lyrics);
      } catch (e) {
        // Ignore cache errors, return lyrics anyway
      }
      
      return Right(lyrics);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}

