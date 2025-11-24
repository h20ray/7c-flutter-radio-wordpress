import '../../../../config/radio_config.dart';
import '../../domain/entities/user_listening_stats_entity.dart';

class UserListeningStatsModel extends UserListeningStatsEntity {
  const UserListeningStatsModel({
    required super.userId,
    required super.totalListeningSeconds,
    required super.currentLevel,
    required super.lastUpdatedAt,
  });

  factory UserListeningStatsModel.initial(String userId) {
    return UserListeningStatsModel(
      userId: userId,
      totalListeningSeconds: 0,
      currentLevel: RadioGameLevel.level1FrequencyWanderer,
      lastUpdatedAt: DateTime.now(),
    );
  }

  factory UserListeningStatsModel.fromEntity(
    UserListeningStatsEntity entity,
  ) {
    return UserListeningStatsModel(
      userId: entity.userId,
      totalListeningSeconds: entity.totalListeningSeconds,
      currentLevel: entity.currentLevel,
      lastUpdatedAt: entity.lastUpdatedAt,
    );
  }

  factory UserListeningStatsModel.fromMap(Map<String, dynamic> map) {
    final levelName = map['level'] as String?;
    final parsedLevel = levelName != null
        ? RadioGameLevel.values.firstWhere(
            (level) => level.name == levelName,
            orElse: () => RadioGameLevel.level1FrequencyWanderer,
          )
        : RadioGameLevel.level1FrequencyWanderer;
    return UserListeningStatsModel(
      userId: map['userId'] as String,
      totalListeningSeconds: map['totalListeningSeconds'] as int,
      currentLevel: parsedLevel,
      lastUpdatedAt: DateTime.tryParse(map['lastUpdatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  UserListeningStatsModel copyWith({
    int? totalListeningSeconds,
    RadioGameLevel? currentLevel,
    DateTime? lastUpdatedAt,
  }) {
    return UserListeningStatsModel(
      userId: userId,
      totalListeningSeconds:
          totalListeningSeconds ?? this.totalListeningSeconds,
      currentLevel: currentLevel ?? this.currentLevel,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'totalListeningSeconds': totalListeningSeconds,
      'level': currentLevel.name,
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
    };
  }
}

