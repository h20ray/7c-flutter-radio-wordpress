part of 'settings_bloc.dart';

@freezed
class SettingsEvent with _$SettingsEvent {
  const factory SettingsEvent.loadOfflineNewsSettings() =
      LoadOfflineNewsSettingsEvent;
  const factory SettingsEvent.updateMaxPosts(int maxPosts) =
      UpdateMaxPostsEvent;
  const factory SettingsEvent.updateMaxSizeMB(int maxSizeMB) =
      UpdateMaxSizeMBEvent;
  const factory SettingsEvent.toggleAutoSave(bool enabled) =
      ToggleAutoSaveEvent;
  const factory SettingsEvent.loadOfflineNewsStats() =
      LoadOfflineNewsStatsEvent;
  const factory SettingsEvent.clearAllOfflinePosts() =
      ClearAllOfflinePostsEvent;
  const factory SettingsEvent.saveSettings() = SaveSettingsEvent;
}
