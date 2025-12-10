import 'dart:math';

import '../../domain/entities/tamtama_economy_entity.dart';

/// TamTama economy model with JSON serialization for Hive persistence
class TamtamaEconomyModel extends TamtamaEconomyEntity {
  const TamtamaEconomyModel({
    required super.userId,
    super.tunePoints,
    super.coins,
    super.todayListeningMinutes,
    super.streakDays,
    super.lastStreakDate,
    super.todayStations,
    super.totalListeningMinutes,
    required super.lastUpdatedAt,
  });

  /// Create initial economy for a new user
  factory TamtamaEconomyModel.initial(String userId) {
    return TamtamaEconomyModel(
      userId: userId,
      tunePoints: 0.0,
      coins: 50.0, // Starting bonus
      todayListeningMinutes: 0,
      streakDays: 0,
      todayStations: const {},
      totalListeningMinutes: 0,
      lastUpdatedAt: DateTime.now(),
    );
  }

  /// Create from entity
  factory TamtamaEconomyModel.fromEntity(TamtamaEconomyEntity entity) {
    return TamtamaEconomyModel(
      userId: entity.userId,
      tunePoints: entity.tunePoints,
      coins: entity.coins,
      todayListeningMinutes: entity.todayListeningMinutes,
      streakDays: entity.streakDays,
      lastStreakDate: entity.lastStreakDate,
      todayStations: entity.todayStations,
      totalListeningMinutes: entity.totalListeningMinutes,
      lastUpdatedAt: entity.lastUpdatedAt,
    );
  }

  /// Create from JSON map
  factory TamtamaEconomyModel.fromMap(Map<String, dynamic> map) {
    final userId = map['userId'] as String?;
    if (userId == null || userId.isEmpty) {
      throw ArgumentError('userId is required');
    }

    return TamtamaEconomyModel(
      userId: userId,
      tunePoints: (map['tunePoints'] as num?)?.toDouble() ?? 0.0,
      coins: (map['coins'] as num?)?.toDouble() ?? 0.0,
      todayListeningMinutes: (map['todayListeningMinutes'] as int?) ?? 0,
      streakDays: (map['streakDays'] as int?) ?? 0,
      lastStreakDate: map['lastStreakDate'] != null
          ? DateTime.tryParse(map['lastStreakDate'] as String)
          : null,
      todayStations: (map['todayStations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          {},
      totalListeningMinutes: (map['totalListeningMinutes'] as int?) ?? 0,
      lastUpdatedAt:
          DateTime.tryParse(map['lastUpdatedAt'] as String? ?? '') ??
              DateTime.now(),
    );
  }

  @override
  TamtamaEconomyModel copyWith({
    String? userId,
    double? tunePoints,
    double? coins,
    int? todayListeningMinutes,
    int? streakDays,
    DateTime? lastStreakDate,
    Set<String>? todayStations,
    int? totalListeningMinutes,
    DateTime? lastUpdatedAt,
  }) {
    return TamtamaEconomyModel(
      userId: userId ?? this.userId,
      tunePoints: tunePoints ?? this.tunePoints,
      coins: coins ?? this.coins,
      todayListeningMinutes:
          todayListeningMinutes ?? this.todayListeningMinutes,
      streakDays: streakDays ?? this.streakDays,
      lastStreakDate: lastStreakDate ?? this.lastStreakDate,
      todayStations: todayStations ?? this.todayStations,
      totalListeningMinutes:
          totalListeningMinutes ?? this.totalListeningMinutes,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }

  /// Convert to JSON map for Hive storage
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'tunePoints': tunePoints,
      'coins': coins,
      'todayListeningMinutes': todayListeningMinutes,
      'streakDays': streakDays,
      'lastStreakDate': lastStreakDate?.toIso8601String(),
      'todayStations': todayStations.toList(),
      'totalListeningMinutes': totalListeningMinutes,
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
    };
  }

  /// Calculate rewards for N minutes of listening
  /// Returns (tunePointsGained, coinsGained, xpGained)
  (double, double, double) calculateListeningRewards(int minutes) {
    const baseTPPerMinute = 1.0;

    final effectiveMinutes = min(minutes, 60); // Cap per session
    final adjustedMultiplier = earningMultiplier;

    final tpGained =
        effectiveMinutes * baseTPPerMinute * streakBonus * diversityBonus * adjustedMultiplier;
    final coinsGained = tpGained * 0.5;
    final xpGained = tpGained * 1.2;

    return (tpGained, coinsGained, xpGained);
  }
}
