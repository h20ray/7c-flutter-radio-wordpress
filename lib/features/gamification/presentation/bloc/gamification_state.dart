part of 'gamification_bloc.dart';

@freezed
class GamificationState with _$GamificationState {
  const factory GamificationState.initial() = _Initial;
  const factory GamificationState.loading() = _Loading;
  const factory GamificationState.loaded(
    GamificationStatusViewData data,
  ) = _Loaded;
  const factory GamificationState.error(Failure failure) = _Error;
}

