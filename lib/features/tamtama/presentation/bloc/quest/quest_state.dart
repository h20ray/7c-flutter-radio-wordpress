part of 'quest_bloc.dart';

@freezed
class QuestState with _$QuestState {
  /// Initial state before quests are loaded
  const factory QuestState.initial() = QuestInitial;
  
  /// Loading quests
  const factory QuestState.loading() = QuestLoading;
  
  /// Quests loaded successfully
  const factory QuestState.loaded({
    required DailyQuestsEntity quests,
  }) = QuestLoaded;
  
  /// Error loading quests
  const factory QuestState.error(String message) = QuestError;
}
