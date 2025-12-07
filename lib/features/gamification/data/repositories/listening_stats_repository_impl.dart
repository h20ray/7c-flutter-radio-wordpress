import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../config/game_radio_time_config.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_listening_stats_entity.dart';
import '../../domain/repositories/listening_stats_repository.dart';
import '../datasources/listening_stats_local_data_source.dart';
import '../datasources/listening_stats_remote_data_source.dart';
import '../models/user_listening_stats_model.dart';

class ListeningStatsRepositoryImpl implements ListeningStatsRepository {
  final ListeningStatsLocalDataSource localDataSource;
  final ListeningStatsRemoteDataSource? remoteDataSource;
  String _currentUserId;
  static const String _guestUserId = 'local_user';

  StreamController<UserListeningStatsEntity>? _controller;

  ListeningStatsRepositoryImpl({
    required this.localDataSource,
    this.remoteDataSource,
    String? initialUserId,
  }) : _currentUserId = initialUserId ?? _guestUserId;

  @override
  String get currentUserId => _currentUserId;

  @override
  Stream<Either<Failure, UserListeningStatsEntity>> watchStats() async* {
    final current = await _loadCurrent();
    yield Right(current);
    _controller ??= StreamController<UserListeningStatsEntity>.broadcast();
    yield* _controller!.stream.map<Either<Failure, UserListeningStatsEntity>>(
      (event) => Right(event),
    );
  }

  @override
  Future<Either<Failure, UserListeningStatsEntity>> addListeningDuration(
    Duration duration,
  ) async {
    try {
      final seconds = duration.inSeconds;
      final current = await _loadCurrent();
      if (seconds <= 0) {
        return Right(current);
      }

      UserListeningStatsEntity baseStats = current;

      if (remoteDataSource != null && _currentUserId != _guestUserId) {
        try {
          final serverStatsResult = await remoteDataSource!
              .getStatsFromServer();
          final serverStats = serverStatsResult;
          final serverSeconds = serverStats.totalListeningSeconds;
          final serverLastUpdated = serverStats.lastUpdatedAt;
          final currentLastUpdated = current.lastUpdatedAt;

          if (serverSeconds < current.totalListeningSeconds &&
              serverLastUpdated.isAfter(currentLastUpdated)) {
            baseStats = serverStats;
          } else if (serverSeconds > current.totalListeningSeconds) {
            baseStats = serverStats;
          }
        } catch (e) {
          // If fetch fails, continue with local stats
        }
      }

      final updatedSeconds = baseStats.totalListeningSeconds + seconds;
      final hours = updatedSeconds / 3600;
      final definition = GameRadioTimeConfig.resolveByHours(hours);
      final updatedModel = UserListeningStatsModel.fromEntity(baseStats)
          .copyWith(
            totalListeningSeconds: updatedSeconds,
            currentLevel: definition.id,
            lastUpdatedAt: DateTime.now(),
          );
      await localDataSource.save(updatedModel);
      await _emit(updatedModel);

      if (remoteDataSource != null && _currentUserId != _guestUserId) {
        unawaited(
          remoteDataSource!.syncStatsToServer(updatedModel).catchError((e) {
            return updatedModel;
          }),
        );
      }

      return Right(updatedModel);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  Future<UserListeningStatsEntity> _loadCurrent() {
    return localDataSource.fetch(_currentUserId);
  }

  Future<void> _emit(UserListeningStatsEntity entity) async {
    _controller ??= StreamController<UserListeningStatsEntity>.broadcast();
    _controller!.add(entity);
  }

  @override
  Future<Either<Failure, UserListeningStatsEntity>> switchToUser(
    String userId,
  ) async {
    try {
      if (_currentUserId == userId) {
        return Right(await _loadCurrent());
      }

      await _flushCurrentSession();

      _currentUserId = userId;
      final userStats = await _loadCurrent();
      await _emit(userStats);
      return Right(userStats);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, UserListeningStatsEntity>> mergeGuestStatsToUser(
    String userId,
  ) async {
    try {
      // If already using user ID, just return current stats
      if (_currentUserId == userId) {
        return Right(await _loadCurrent());
      }

      // Flush any pending session before merging
      await _flushCurrentSession();

      final guestStats = await localDataSource.fetch(_guestUserId);
      final userStats = await localDataSource.fetch(userId);

      // Only merge if guest has actual listening time
      // If guest stats are suspiciously high (likely contains previous user stats),
      // don't merge to prevent duplication
      if (guestStats.totalListeningSeconds > 0) {
        // Merge guest stats with user stats (additive)
        final mergedSeconds =
            guestStats.totalListeningSeconds + userStats.totalListeningSeconds;
        final mergedHours = mergedSeconds / 3600;
        final definition = GameRadioTimeConfig.resolveByHours(mergedHours);

        final mergedStats = UserListeningStatsModel(
          userId: userId,
          totalListeningSeconds: mergedSeconds,
          currentLevel: definition.id,
          lastUpdatedAt: DateTime.now(),
        );

        await localDataSource.save(mergedStats);

        // Clear guest stats after successful merge
        final clearedGuestStats = UserListeningStatsModel.initial(_guestUserId);
        await localDataSource.save(clearedGuestStats);

        // Switch to user ID
        _currentUserId = userId;
        await _emit(mergedStats);

        if (remoteDataSource != null) {
          unawaited(
            remoteDataSource!.syncStatsToServer(mergedStats).catchError((e) {
              // Log error but don't fail the operation - fire and forget
              return mergedStats;
            }),
          );
        }

        return Right(mergedStats);
      } else {
        // No guest stats to merge, just switch to user
        _currentUserId = userId;

        // Ensure user entry exists in database (even with 0 stats)
        if (userStats.totalListeningSeconds == 0) {
          final initialStats = UserListeningStatsModel.initial(userId);
          await localDataSource.save(initialStats);

          if (remoteDataSource != null) {
            unawaited(
              remoteDataSource!.syncStatsToServer(initialStats).catchError((e) {
                return initialStats;
              }),
            );
          }

          await _emit(initialStats);
          return Right(initialStats);
        }

        await _emit(userStats);

        if (remoteDataSource != null) {
          unawaited(
            remoteDataSource!
                .syncStatsToServer(UserListeningStatsModel.fromEntity(userStats))
                .catchError((e) {
                  return UserListeningStatsModel.fromEntity(userStats);
                }),
          );
        }

        return Right(userStats);
      }
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, UserListeningStatsEntity>> flushToGuest() async {
    try {
      if (_currentUserId == _guestUserId) {
        return Right(await _loadCurrent());
      }

      await _flushCurrentSession();

      final guestStats = await localDataSource.fetch(_guestUserId);

      _currentUserId = _guestUserId;
      await _emit(guestStats);
      return Right(guestStats);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, UserListeningStatsEntity>> syncWithServer(
    String userId,
    UserListeningStatsEntity serverStats,
  ) async {
    try {
      final localStats = await localDataSource.fetch(userId);

      final serverSeconds = serverStats.totalListeningSeconds;
      final localSeconds = localStats.totalListeningSeconds;

      final serverLastUpdated = serverStats.lastUpdatedAt;
      final localLastUpdated = localStats.lastUpdatedAt;

      int finalSeconds;
      bool shouldUploadToServer = false;

      if (serverSeconds >= localSeconds) {
        finalSeconds = serverSeconds;
      } else {
        if (serverLastUpdated.isAfter(localLastUpdated)) {
          finalSeconds = serverSeconds;
        } else {
          finalSeconds = localSeconds;
          shouldUploadToServer = true;
        }
      }

      final mergedHours = finalSeconds / 3600;
      final definition = GameRadioTimeConfig.resolveByHours(mergedHours);
      final finalLevelResolved = definition.id;

      final syncedStats = UserListeningStatsModel(
        userId: userId,
        totalListeningSeconds: finalSeconds,
        currentLevel: finalLevelResolved,
        lastUpdatedAt: DateTime.now(),
      );

      await localDataSource.save(syncedStats);

      if (_currentUserId == userId) {
        await _emit(syncedStats);
      }

      if (remoteDataSource != null &&
          userId != _guestUserId &&
          shouldUploadToServer) {
        unawaited(
          remoteDataSource!.syncStatsToServer(syncedStats).catchError((e) {
            return syncedStats;
          }),
        );
      }

      return Right(syncedStats);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, UserListeningStatsEntity>> fetchFromServer(
    String userId,
  ) async {
    if (remoteDataSource == null || userId == _guestUserId) {
      return const Left(ServerFailure('Cannot fetch server stats for guest user'));
    }

    try {
      final serverStats = await remoteDataSource!.getStatsFromServer();
      return Right(serverStats);
    } catch (error) {
      return Left(
        ServerFailure('Failed to fetch stats from server: ${error.toString()}'),
      );
    }
  }

  Future<void> _flushCurrentSession() async {
    try {
      final current = await _loadCurrent();
      if (current.totalListeningSeconds > 0) {
        await localDataSource.save(
          UserListeningStatsModel.fromEntity(
            current,
          ).copyWith(lastUpdatedAt: DateTime.now()),
        );
      }
    } catch (error) {
      // Ignore flush errors
    }
  }
}
