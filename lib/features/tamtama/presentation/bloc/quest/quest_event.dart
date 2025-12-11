part of 'quest_bloc.dart';

@freezed
class QuestEvent with _$QuestEvent {
  /// Load or refresh daily quests
  const factory QuestEvent.load() = LoadQuestsEvent;
  
  /// Increment progress for a specific quest type
  const factory QuestEvent.incrementProgress({
    required QuestType type,
    @Default(1) int amount,
  }) = IncrementProgressEvent;
  
  /// Claim rewards for a specific quest
  const factory QuestEvent.claimQuest(String questId) = ClaimQuestEvent;
  
  /// Claim all available quest rewards
  const factory QuestEvent.claimAll() = ClaimAllQuestsEvent;
  
  /// Refresh quests if needed (e.g., on new day)
  const factory QuestEvent.refresh() = RefreshQuestsEvent;
}
