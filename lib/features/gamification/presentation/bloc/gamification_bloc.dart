import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user_listening_stats_entity.dart';
import '../../domain/usecases/watch_listening_stats.dart';
import '../viewmodels/gamification_status_view_data.dart';

part 'gamification_bloc.freezed.dart';
part 'gamification_event.dart';
part 'gamification_state.dart';

class GamificationBloc extends Bloc<GamificationEvent, GamificationState> {
  final WatchListeningStats watchListeningStats;
  StreamSubscription<Either<Failure, UserListeningStatsEntity>>?
      _subscription;

  GamificationBloc({required this.watchListeningStats})
      : super(const GamificationState.initial()) {
    on<_Started>(_onStarted);
    on<_StatsUpdated>(_onStatsUpdated);
    on<_StatsFailed>(_onStatsFailed);
  }

  void _onStarted(_Started event, Emitter<GamificationState> emit) {
    emit(const GamificationState.loading());
    _subscription?.cancel();
    _subscription = watchListeningStats().listen((result) {
      result.fold(
        (failure) => add(GamificationEvent.statsFailed(failure)),
        (stats) => add(GamificationEvent.statsUpdated(stats)),
      );
    });
  }

  void _onStatsUpdated(
    _StatsUpdated event,
    Emitter<GamificationState> emit,
  ) {
    final viewData = GamificationStatusViewData.fromEntity(event.stats);
    emit(GamificationState.loaded(viewData));
  }

  void _onStatsFailed(
    _StatsFailed event,
    Emitter<GamificationState> emit,
  ) {
    emit(GamificationState.error(event.failure));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

