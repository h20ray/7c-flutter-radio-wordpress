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
  final String userId;

  StreamController<UserListeningStatsEntity>? _controller;

  ListeningStatsRepositoryImpl({
    required this.localDataSource,
    this.userId = 'local_user',
  });

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
    return localDataSource.fetch(userId);
  }

  Future<void> _emit(UserListeningStatsEntity entity) async {
    _controller ??= StreamController<UserListeningStatsEntity>.broadcast();
    _controller!.add(entity);
  }

}

