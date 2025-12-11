import 'package:equatable/equatable.dart';

/// Types of daily quests available
enum QuestType {
  /// Listen to radio for X minutes
  listening,
  
  /// Feed pet X times
  feeding,
  
  /// Clean pet X times
  cleaning,
  
  /// Play with pet X times
  playing,
  
  /// Keep pet happy for X hours
  keepHappy,
  
  /// Login streak
  dailyLogin,
}

/// A single quest with progress tracking
class QuestEntity extends Equatable {
  final String id;
  final QuestType type;
  final String title;
  final String description;
  final int targetValue;
  final int currentValue;
  final int rewardCoins;
  final int rewardXp;
  final DateTime createdAt;
  final DateTime? completedAt;
  final bool isClaimed;
  
  const QuestEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.targetValue,
    this.currentValue = 0,
    required this.rewardCoins,
    required this.rewardXp,
    required this.createdAt,
    this.completedAt,
    this.isClaimed = false,
  });
  
  /// Progress as percentage (0.0 - 1.0)
  double get progress => (currentValue / targetValue).clamp(0.0, 1.0);
  
  /// Whether the quest goal has been met
  bool get isCompleted => currentValue >= targetValue;
  
  /// Whether the quest can be claimed (completed but not yet claimed)
  bool get canClaim => isCompleted && !isClaimed;
  
  /// Create a copy with updated values
  QuestEntity copyWith({
    String? id,
    QuestType? type,
    String? title,
    String? description,
    int? targetValue,
    int? currentValue,
    int? rewardCoins,
    int? rewardXp,
    DateTime? createdAt,
    DateTime? completedAt,
    bool? isClaimed,
  }) {
    return QuestEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      rewardCoins: rewardCoins ?? this.rewardCoins,
      rewardXp: rewardXp ?? this.rewardXp,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      isClaimed: isClaimed ?? this.isClaimed,
    );
  }
  
  /// Increment progress by amount
  QuestEntity incrementProgress(int amount) {
    final newValue = (currentValue + amount).clamp(0, targetValue);
    return copyWith(
      currentValue: newValue,
      completedAt: newValue >= targetValue && completedAt == null 
          ? DateTime.now() 
          : completedAt,
    );
  }
  
  /// Mark quest as claimed
  QuestEntity markClaimed() {
    return copyWith(isClaimed: true);
  }
  
  @override
  List<Object?> get props => [
    id,
    type,
    title,
    description,
    targetValue,
    currentValue,
    rewardCoins,
    rewardXp,
    createdAt,
    completedAt,
    isClaimed,
  ];
}

/// Collection of daily quests
class DailyQuestsEntity extends Equatable {
  final String date; // YYYY-MM-DD format
  final List<QuestEntity> quests;
  final DateTime createdAt;
  
  const DailyQuestsEntity({
    required this.date,
    required this.quests,
    required this.createdAt,
  });
  
  /// Check if quests are from today
  bool get isToday {
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    return date == todayStr;
  }
  
  /// Number of completed quests
  int get completedCount => quests.where((q) => q.isCompleted).length;
  
  /// Number of claimed quests
  int get claimedCount => quests.where((q) => q.isClaimed).length;
  
  /// Total reward coins available to claim
  int get pendingCoins => quests
      .where((q) => q.canClaim)
      .fold(0, (sum, q) => sum + q.rewardCoins);
  
  /// Total reward XP available to claim
  int get pendingXp => quests
      .where((q) => q.canClaim)
      .fold(0, (sum, q) => sum + q.rewardXp);
  
  DailyQuestsEntity copyWith({
    String? date,
    List<QuestEntity>? quests,
    DateTime? createdAt,
  }) {
    return DailyQuestsEntity(
      date: date ?? this.date,
      quests: quests ?? this.quests,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  
  /// Update a specific quest
  DailyQuestsEntity updateQuest(String questId, QuestEntity Function(QuestEntity) update) {
    final updatedQuests = quests.map((q) {
      if (q.id == questId) {
        return update(q);
      }
      return q;
    }).toList();
    return copyWith(quests: updatedQuests);
  }
  
  @override
  List<Object?> get props => [date, quests, createdAt];
}
