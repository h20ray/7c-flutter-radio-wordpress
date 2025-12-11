import '../entities/quest_entity.dart';

/// Service for generating and managing daily quests
class QuestService {
  /// Generate a fresh set of daily quests
  DailyQuestsEntity generateDailyQuests() {
    final now = DateTime.now();
    final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    
    return DailyQuestsEntity(
      date: dateStr,
      quests: [
        // Listening Quest
        QuestEntity(
          id: '${dateStr}_listening',
          type: QuestType.listening,
          title: 'Tune In',
          description: 'Listen to radio for 30 minutes',
          targetValue: 30,
          rewardCoins: 50,
          rewardXp: 25,
          createdAt: now,
        ),
        // Feeding Quest
        QuestEntity(
          id: '${dateStr}_feeding',
          type: QuestType.feeding,
          title: 'Snack Time',
          description: 'Feed your pet 3 times',
          targetValue: 3,
          rewardCoins: 30,
          rewardXp: 15,
          createdAt: now,
        ),
        // Cleaning Quest
        QuestEntity(
          id: '${dateStr}_cleaning',
          type: QuestType.cleaning,
          title: 'Squeaky Clean',
          description: 'Clean your pet 2 times',
          targetValue: 2,
          rewardCoins: 20,
          rewardXp: 10,
          createdAt: now,
        ),
        // Playing Quest
        QuestEntity(
          id: '${dateStr}_playing',
          type: QuestType.playing,
          title: 'Playtime!',
          description: 'Play with your pet 3 times',
          targetValue: 3,
          rewardCoins: 40,
          rewardXp: 20,
          createdAt: now,
        ),
        // Daily Login Quest
        QuestEntity(
          id: '${dateStr}_login',
          type: QuestType.dailyLogin,
          title: 'Daily Check-in',
          description: 'Open the app today',
          targetValue: 1,
          currentValue: 1, // Auto-completed on generation
          rewardCoins: 10,
          rewardXp: 5,
          createdAt: now,
          completedAt: now,
        ),
      ],
      createdAt: now,
    );
  }
  
  /// Check if quests need to be refreshed (new day)
  bool needsRefresh(DailyQuestsEntity? current) {
    if (current == null) return true;
    return !current.isToday;
  }
  
  /// Calculate total rewards from claiming all available quests
  ({int coins, int xp}) calculatePendingRewards(DailyQuestsEntity quests) {
    return (
      coins: quests.pendingCoins,
      xp: quests.pendingXp,
    );
  }
  
  /// Increment quest progress by type
  DailyQuestsEntity incrementQuestProgress(
    DailyQuestsEntity quests,
    QuestType type,
    int amount,
  ) {
    final updatedQuests = quests.quests.map((q) {
      if (q.type == type && !q.isCompleted) {
        return q.incrementProgress(amount);
      }
      return q;
    }).toList();
    
    return quests.copyWith(quests: updatedQuests);
  }
  
  /// Claim a specific quest
  ({DailyQuestsEntity quests, int coins, int xp}) claimQuest(
    DailyQuestsEntity quests,
    String questId,
  ) {
    int claimedCoins = 0;
    int claimedXp = 0;
    
    final updatedQuests = quests.quests.map((q) {
      if (q.id == questId && q.canClaim) {
        claimedCoins = q.rewardCoins;
        claimedXp = q.rewardXp;
        return q.markClaimed();
      }
      return q;
    }).toList();
    
    return (
      quests: quests.copyWith(quests: updatedQuests),
      coins: claimedCoins,
      xp: claimedXp,
    );
  }
  
  /// Claim all available quests
  ({DailyQuestsEntity quests, int coins, int xp}) claimAllQuests(
    DailyQuestsEntity quests,
  ) {
    int totalCoins = 0;
    int totalXp = 0;
    
    final updatedQuests = quests.quests.map((q) {
      if (q.canClaim) {
        totalCoins += q.rewardCoins;
        totalXp += q.rewardXp;
        return q.markClaimed();
      }
      return q;
    }).toList();
    
    return (
      quests: quests.copyWith(quests: updatedQuests),
      coins: totalCoins,
      xp: totalXp,
    );
  }
}
