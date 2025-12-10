import 'package:equatable/equatable.dart';

/// Economy state for TamTama including Tune Points and Coins
class TamtamaEconomyEntity extends Equatable {
  final String userId;
  
  /// Tune Points earned from listening (main currency)
  final double tunePoints;
  
  /// Coins derived from Tune Points (used for purchases)
  final double coins;
  
  /// Minutes listened today (resets daily)
  final int todayListeningMinutes;
  
  /// Consecutive days with >= MIN_DAILY_MINUTES listening
  final int streakDays;
  
  /// Last date the streak was updated
  final DateTime? lastStreakDate;
  
  /// Unique station IDs listened to today (for diversity bonus)
  final Set<String> todayStations;
  
  /// Total lifetime listening minutes
  final int totalListeningMinutes;
  
  /// Last time economy was updated
  final DateTime lastUpdatedAt;

  const TamtamaEconomyEntity({
    required this.userId,
    this.tunePoints = 0.0,
    this.coins = 0.0,
    this.todayListeningMinutes = 0,
    this.streakDays = 0,
    this.lastStreakDate,
    this.todayStations = const {},
    this.totalListeningMinutes = 0,
    required this.lastUpdatedAt,
  });

  /// Minimum daily listening minutes to maintain streak
  static const int minDailyMinutesForStreak = 30;
  
  /// Maximum daily minutes before diminishing returns
  static const int maxEffectiveMinutesPerDay = 240; // 4 hours
  
  /// Check if we're in diminishing returns territory
  bool get hasDiminishingReturns => todayListeningMinutes > maxEffectiveMinutesPerDay;
  
  /// Current earning multiplier (accounts for diminishing returns)
  double get earningMultiplier {
    if (todayListeningMinutes <= maxEffectiveMinutesPerDay) {
      return 1.0;
    }
    // 25% earnings after 4 hours
    return 0.25;
  }
  
  /// Streak bonus multiplier (up to +70% at 14 days)
  double get streakBonus => 1.0 + (0.05 * streakDays.clamp(0, 14));
  
  /// Station diversity bonus (small bonus for variety)
  double get diversityBonus => 1.0 + (0.02 * (todayStations.length - 1).clamp(0, 10));

  TamtamaEconomyEntity copyWith({
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
    return TamtamaEconomyEntity(
      userId: userId ?? this.userId,
      tunePoints: tunePoints ?? this.tunePoints,
      coins: coins ?? this.coins,
      todayListeningMinutes: todayListeningMinutes ?? this.todayListeningMinutes,
      streakDays: streakDays ?? this.streakDays,
      lastStreakDate: lastStreakDate ?? this.lastStreakDate,
      todayStations: todayStations ?? this.todayStations,
      totalListeningMinutes: totalListeningMinutes ?? this.totalListeningMinutes,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    tunePoints,
    coins,
    todayListeningMinutes,
    streakDays,
    lastStreakDate,
    todayStations,
    totalListeningMinutes,
    lastUpdatedAt,
  ];
}
