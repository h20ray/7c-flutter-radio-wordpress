part of 'gamification_bloc.dart';

@freezed
class GamificationEvent with _$GamificationEvent {
  const factory GamificationEvent.started() = _Started;
  const factory GamificationEvent.statsUpdated(
    UserListeningStatsEntity stats,
  ) = _StatsUpdated;
  const factory GamificationEvent.statsFailed(Failure failure) = _StatsFailed;
}

