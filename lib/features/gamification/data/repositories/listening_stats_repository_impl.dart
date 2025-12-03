import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../config/game_radio_time_config.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_listening_stats_entity.dart';
import '../../domain/repositories/listening_stats_repository.dart';
import '../datasources/listening_stats_local_data_source.dart';
import '../models/user_listening_stats_model.dart';

class ListeningStatsRepositoryImpl implements ListeningStatsRepository {
  final ListeningStatsLocalDataSource localDataSource;
  String _currentUserId;
  static const String _guestUserId = 'local_user';

  StreamController<UserListeningStatsEntity>? _controller;

  ListeningStatsRepositoryImpl({
    required this.localDataSource,
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
      final updatedSeconds = current.totalListeningSeconds + seconds;
      final hours = updatedSeconds / 3600;
      final definition = GameRadioTimeConfig.resolveByHours(hours);
      final updatedModel = UserListeningStatsModel.fromEntity(current).copyWith(
        totalListeningSeconds: updatedSeconds,
        currentLevel: definition.id,
        lastUpdatedAt: DateTime.now(),
      );
      await localDataSource.save(updatedModel);
      await _emit(updatedModel);
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

      // Merge guest stats with user stats (additive)
      final mergedSeconds = guestStats.totalListeningSeconds +
          userStats.totalListeningSeconds;
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
      return Right(mergedStats);
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

      final currentStats = await _loadCurrent();
      await _flushCurrentSession();

      final guestStats = await localDataSource.fetch(_guestUserId);
      
      final mergedSeconds =
          guestStats.totalListeningSeconds + currentStats.totalListeningSeconds;
      final mergedHours = mergedSeconds / 3600;
      final definition = GameRadioTimeConfig.resolveByHours(mergedHours);

      final mergedGuestStats = UserListeningStatsModel(
        userId: _guestUserId,
        totalListeningSeconds: mergedSeconds,
        currentLevel: definition.id,
        lastUpdatedAt: DateTime.now(),
      );

      await localDataSource.save(mergedGuestStats);

      _currentUserId = _guestUserId;
      await _emit(mergedGuestStats);
      return Right(mergedGuestStats);
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

      final mergedSeconds = serverSeconds > localSeconds
          ? serverSeconds
          : localSeconds;
      final mergedHours = mergedSeconds / 3600;
      final definition = GameRadioTimeConfig.resolveByHours(mergedHours);

      final syncedStats = UserListeningStatsModel(
        userId: userId,
        totalListeningSeconds: mergedSeconds,
        currentLevel: definition.id,
        lastUpdatedAt: DateTime.now(),
      );

      await localDataSource.save(syncedStats);

      if (_currentUserId == userId) {
        await _emit(syncedStats);
      }

      return Right(syncedStats);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  Future<void> _flushCurrentSession() async {
    try {
      final current = await _loadCurrent();
      if (current.totalListeningSeconds > 0) {
        await localDataSource.save(
          UserListeningStatsModel.fromEntity(current).copyWith(
            lastUpdatedAt: DateTime.now(),
          ),
        );
      }
    } catch (error) {
      // Ignore flush errors
    }
  }
}

