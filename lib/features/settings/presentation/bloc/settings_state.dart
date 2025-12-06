part of 'settings_bloc.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState.initial() = _Initial;
  
  const factory SettingsState.loading() = _Loading;
  
  const factory SettingsState.loaded({
    required OfflineNewsSettingsEntity settings,
    required OfflineNewsStats? stats,
    @Default(false) bool isSaving,
    Failure? error,
  }) = _Loaded;
  
  const factory SettingsState.error({
    required Failure failure,
  }) = _Error;
}

