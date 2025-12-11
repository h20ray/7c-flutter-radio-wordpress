import 'package:equatable/equatable.dart';

import 'pet_history.dart';

/// Life stages for TamTama evolution
enum LifeStage {
  egg,
  baby,
  child,
  teen,
  adult,
  specialAdult,
}

/// Current behavioral state of the pet
enum PetState {
  idle,
  listening,
  sleeping,
  sick,
  evolving,
}

/// Personality archetypes determined at Adult stage evolution
enum PersonalityArchetype {
  djStar,       // High listening, high happiness, good routine
  chillLoFi,    // Moderate listening, low stress, low activity
  hyperDance,   // Very high listening, high happiness, low sleep
  scholarNerd,  // High discipline in care, moderate listening
  rebelStatic,  // Neglected, stressed, random moods
  ghostSignal,  // Extreme neglect / long absence
  carebearHost, // High affection and interaction, maybe low listening
}

/// Food types with different effects and costs
enum FoodType {
  snack,  // +30 hunger, cheap
  meal,   // +60 hunger, moderate cost
  treat,  // +15 hunger, +10 happiness, moderate cost
}

/// Activity types for playing with pet
enum ActivityType {
  quickPlay,  // +8 happiness, -5 energy
  fullGame,   // +15 happiness, -10 energy
  adventure,  // +20 happiness, -15 energy, high affection
}

/// Core TamTama entity representing the virtual pet state
class TamtamaEntity extends Equatable {
  // Identity
  final String userId;
  final String petName;
  final int backgroundIndex;
  final int eggIndex;
  final int familyIndex;  // Pet family (1-7)
  final int? petId;       // Numeric form ID (e.g., 15011)
  final String? currentFormId; // sprite identifier (legacy)

  // Core Stats (0.0 - 100.0)
  final double hunger;    // 0 = starving, 100 = full
  final double energy;    // 0 = exhausted, 100 = fully rested
  final double happiness; // 0 = depressed, 100 = joyful
  final double hygiene;   // 0 = filthy, 100 = clean
  final double affection; // bond with user (long-term)
  final double stress;    // 0 = calm, 100 = very stressed
  final double health;    // derived from neglect (0-100)

  // Meta Stats
  final int level;        // 1-50
  final double xp;        // experience points
  final LifeStage lifeStage;
  final PetState petState;
  final PersonalityArchetype? archetype; // determined at Adult
  final double neglectScore; // 0-100, accumulates from unmet needs

  // Timestamps
  final DateTime createdAt;
  final DateTime lastUpdateAt;
  final DateTime? lastFedAt;
  final DateTime? lastPlayedAt;
  final DateTime? lastCleanedAt;
  final DateTime? lastSleptAt;

  // Evolution tracking
  final List<String> evolutionHistory;
  final PetHistory history;
  
  // Teen stage averages for evolution scoring (normalized 0-1)
  final double avgRoutineQuality;
  final double avgHappiness;
  final double avgStress;
  final double avgAffection;
  final double avgListeningMinutesPerDay;
  final double avgStationDiversity;
  final double neglectScoreTeen;

  const TamtamaEntity({
    required this.userId,
    required this.petName,
    required this.backgroundIndex,
    required this.eggIndex,
    this.familyIndex = 1,
    this.petId,
    this.currentFormId,
    required this.hunger,
    required this.energy,
    required this.happiness,
    required this.hygiene,
    required this.affection,
    required this.stress,
    required this.health,
    required this.level,
    required this.xp,
    required this.lifeStage,
    required this.petState,
    this.archetype,
    required this.neglectScore,
    required this.createdAt,
    required this.lastUpdateAt,
    this.lastFedAt,
    this.lastPlayedAt,
    this.lastCleanedAt,
    this.lastSleptAt,
    this.evolutionHistory = const [],
    this.history = const PetHistory(),
    this.avgRoutineQuality = 0.0,
    this.avgHappiness = 0.0,
    this.avgStress = 0.0,
    this.avgAffection = 0.0,
    this.avgListeningMinutesPerDay = 0.0,
    this.avgStationDiversity = 0.0,
    this.neglectScoreTeen = 0.0,
  });

  // Computed properties
  bool get isStarving => hunger < 10;
  bool get isDirty => hygiene < 20;
  bool get isOvertired => energy < 10;
  bool get isLonely => affection < 20;
  bool get isSick => health < 30;
  bool get isHungry => hunger < 50;
  bool get isHappy => happiness >= 70;
  bool get needsAttention => hunger < 30 || happiness < 30 || hygiene < 30 || energy < 20;
  
  /// Overall mood score (0-100)
  double get moodScore {
    final positives = happiness + (100 - stress) + affection;
    final negatives = (isStarving ? 30 : 0) + (isDirty ? 20 : 0) + (isOvertired ? 25 : 0);
    return ((positives / 3) - negatives).clamp(0, 100);
  }

  /// XP required for next level
  double get xpForNextLevel => level * 100.0;
  
  /// Progress to next level (0.0 - 1.0)
  double get levelProgress => (xp / xpForNextLevel).clamp(0.0, 1.0);

  TamtamaEntity copyWith({
    String? userId,
    String? petName,
    int? backgroundIndex,
    int? eggIndex,
    int? familyIndex,
    int? petId,
    String? currentFormId,
    double? hunger,
    double? energy,
    double? happiness,
    double? hygiene,
    double? affection,
    double? stress,
    double? health,
    int? level,
    double? xp,
    LifeStage? lifeStage,
    PetState? petState,
    PersonalityArchetype? archetype,
    double? neglectScore,
    DateTime? createdAt,
    DateTime? lastUpdateAt,
    DateTime? lastFedAt,
    DateTime? lastPlayedAt,
    DateTime? lastCleanedAt,
    DateTime? lastSleptAt,
    List<String>? evolutionHistory,
    PetHistory? history,
    double? avgRoutineQuality,
    double? avgHappiness,
    double? avgStress,
    double? avgAffection,
    double? avgListeningMinutesPerDay,
    double? avgStationDiversity,
    double? neglectScoreTeen,
  }) {
    return TamtamaEntity(
      userId: userId ?? this.userId,
      petName: petName ?? this.petName,
      backgroundIndex: backgroundIndex ?? this.backgroundIndex,
      eggIndex: eggIndex ?? this.eggIndex,
      familyIndex: familyIndex ?? this.familyIndex,
      petId: petId ?? this.petId,
      currentFormId: currentFormId ?? this.currentFormId,
      hunger: hunger ?? this.hunger,
      energy: energy ?? this.energy,
      happiness: happiness ?? this.happiness,
      hygiene: hygiene ?? this.hygiene,
      affection: affection ?? this.affection,
      stress: stress ?? this.stress,
      health: health ?? this.health,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      lifeStage: lifeStage ?? this.lifeStage,
      petState: petState ?? this.petState,
      archetype: archetype ?? this.archetype,
      neglectScore: neglectScore ?? this.neglectScore,
      createdAt: createdAt ?? this.createdAt,
      lastUpdateAt: lastUpdateAt ?? this.lastUpdateAt,
      lastFedAt: lastFedAt ?? this.lastFedAt,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      lastCleanedAt: lastCleanedAt ?? this.lastCleanedAt,
      lastSleptAt: lastSleptAt ?? this.lastSleptAt,
      evolutionHistory: evolutionHistory ?? this.evolutionHistory,
      history: history ?? this.history,
      avgRoutineQuality: avgRoutineQuality ?? this.avgRoutineQuality,
      avgHappiness: avgHappiness ?? this.avgHappiness,
      avgStress: avgStress ?? this.avgStress,
      avgAffection: avgAffection ?? this.avgAffection,
      avgListeningMinutesPerDay: avgListeningMinutesPerDay ?? this.avgListeningMinutesPerDay,
      avgStationDiversity: avgStationDiversity ?? this.avgStationDiversity,
      neglectScoreTeen: neglectScoreTeen ?? this.neglectScoreTeen,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    petName,
    backgroundIndex,
    eggIndex,
    familyIndex,
    petId,
    currentFormId,
    hunger,
    energy,
    happiness,
    hygiene,
    affection,
    stress,
    health,
    level,
    xp,
    lifeStage,
    petState,
    archetype,
    neglectScore,
    createdAt,
    lastUpdateAt,
    lastFedAt,
    lastPlayedAt,
    lastCleanedAt,
    lastSleptAt,
    evolutionHistory,
    history,
    avgRoutineQuality,
    avgHappiness,
    avgStress,
    avgAffection,
    avgListeningMinutesPerDay,
    avgStationDiversity,
    neglectScoreTeen,
  ];
}
