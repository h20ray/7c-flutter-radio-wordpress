import '../../../../config/game_radio_time_config.dart';
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
      currentLevel: GameRadioTimeConfig.getFirstLevel().id,
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
    final levelValue = map['level'] as String?;
    String levelId;

    if (levelValue == null || levelValue.isEmpty) {
      levelId = GameRadioTimeConfig.getFirstLevel().id;
    } else {
      levelId = _migrateLevelFromEnum(levelValue);
    }

    return UserListeningStatsModel(
      userId: map['userId'] as String,
      totalListeningSeconds: map['totalListeningSeconds'] as int,
      currentLevel: levelId,
      lastUpdatedAt: DateTime.tryParse(map['lastUpdatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  static String _migrateLevelFromEnum(String levelValue) {
    final enumToIdMap = {
      'level1FrequencyWanderer': 'level_1',
      'level2ActiveTuner': 'level_2',
      'level3StudioCompanion': 'level_3',
      'level4AirwaveCitizen': 'level_4',
      'level5RadioStar': 'level_5',
      'level6BroadcastLegend': 'level_6',
    };

    if (enumToIdMap.containsKey(levelValue)) {
      return enumToIdMap[levelValue]!;
    }

    final existingLevel = GameRadioTimeConfig.getLevelById(levelValue);
    if (existingLevel != null) {
      return levelValue;
    }

    return GameRadioTimeConfig.getFirstLevel().id;
  }

  UserListeningStatsModel copyWith({
    int? totalListeningSeconds,
    String? currentLevel,
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
      'level': currentLevel,
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
    };
  }
}

