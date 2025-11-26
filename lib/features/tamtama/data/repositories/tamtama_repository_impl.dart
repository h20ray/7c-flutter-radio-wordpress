import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/tamtama_entity.dart';
import '../../domain/repositories/tamtama_repository.dart';
import '../datasources/tamtama_local_data_source.dart';
import '../models/tamtama_model.dart';

class TamtamaRepositoryImpl implements TamtamaRepository {
  final TamtamaLocalDataSource localDataSource;
  final String userId;

  StreamController<TamtamaEntity>? _controller;

  TamtamaRepositoryImpl({
    required this.localDataSource,
    this.userId = 'local_user',
  });

  @override
  Future<Either<Failure, TamtamaEntity>> fetch(String userId) async {
    try {
      final tamtama = await localDataSource.fetch(userId);
      return Right(tamtama);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, TamtamaEntity>> save(TamtamaEntity tamtama) async {
    try {
      final model = TamtamaModel.fromEntity(tamtama);
      await localDataSource.save(model);
      await _emit(model);
      return Right(model);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  @override
  Stream<Either<Failure, TamtamaEntity>> watch(String userId) async* {
    try {
      final current = await localDataSource.fetch(userId);
      yield Right(current);
      _controller ??= StreamController<TamtamaEntity>.broadcast();
      yield* _controller!.stream.map<Either<Failure, TamtamaEntity>>(
        (event) => Right(event),
      );
    } catch (error) {
      yield Left(CacheFailure(error.toString()));
    }
  }

  Future<void> _emit(TamtamaEntity entity) async {
    _controller ??= StreamController<TamtamaEntity>.broadcast();
    _controller!.add(entity);
  }
}

