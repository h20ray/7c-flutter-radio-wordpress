import 'dart:math';

import '../../domain/entities/pet_history.dart';
import '../../domain/entities/tamtama_entity.dart';

/// TamTama model with JSON serialization for Hive persistence
class TamtamaModel extends TamtamaEntity {
  const TamtamaModel({
    required super.userId,
    required super.petName,
    required super.backgroundIndex,
    required super.eggIndex,
    super.familyIndex,
    super.petId,
    super.currentFormId,
    required super.hunger,
    required super.energy,
    required super.happiness,
    required super.hygiene,
    required super.affection,
    required super.stress,
    required super.health,
    required super.level,
    required super.xp,
    required super.lifeStage,
    required super.petState,
    super.archetype,
    required super.neglectScore,
    required super.createdAt,
    required super.lastUpdateAt,
    super.lastFedAt,
    super.lastPlayedAt,
    super.lastCleanedAt,
    super.lastSleptAt,
    super.evolutionHistory,
    super.history,
    super.avgRoutineQuality,
    super.avgHappiness,
    super.avgStress,
    super.avgAffection,
    super.avgListeningMinutesPerDay,
    super.avgStationDiversity,
    super.neglectScoreTeen,
  });

  static const int totalBackgrounds = 20;
  static const int totalEggs = 4;

  /// Create a new TamTama with initial values
  factory TamtamaModel.initial(String userId) {
    final random = Random();
    final backgroundIndex = random.nextInt(totalBackgrounds) + 1;
    final eggIndex = random.nextInt(totalEggs) + 1;
    final petName = _generateRandomPetName();
    final now = DateTime.now();

    return TamtamaModel(
      userId: userId,
      petName: petName,
      backgroundIndex: backgroundIndex,
      eggIndex: eggIndex,
      familyIndex: 1,
      petId: 11010 + (eggIndex - 1),  // Default egg ID based on egg variant
      hunger: 80.0,
      energy: 100.0,
      happiness: 70.0,
      hygiene: 100.0,
      affection: 30.0,
      stress: 10.0,
      health: 100.0,
      level: 1,
      xp: 0.0,
      lifeStage: LifeStage.egg,
      petState: PetState.idle,
      neglectScore: 0.0,
      createdAt: now,
      lastUpdateAt: now,
      history: PetHistory(stageHistory: [11010 + (eggIndex - 1)]),
    );
  }

  /// Create from existing entity
  factory TamtamaModel.fromEntity(TamtamaEntity entity) {
    return TamtamaModel(
      userId: entity.userId,
      petName: entity.petName,
      backgroundIndex: entity.backgroundIndex,
      eggIndex: entity.eggIndex,
      familyIndex: entity.familyIndex,
      petId: entity.petId,
      currentFormId: entity.currentFormId,
      hunger: entity.hunger,
      energy: entity.energy,
      happiness: entity.happiness,
      hygiene: entity.hygiene,
      affection: entity.affection,
      stress: entity.stress,
      health: entity.health,
      level: entity.level,
      xp: entity.xp,
      lifeStage: entity.lifeStage,
      petState: entity.petState,
      archetype: entity.archetype,
      neglectScore: entity.neglectScore,
      createdAt: entity.createdAt,
      lastUpdateAt: entity.lastUpdateAt,
      lastFedAt: entity.lastFedAt,
      lastPlayedAt: entity.lastPlayedAt,
      lastCleanedAt: entity.lastCleanedAt,
      lastSleptAt: entity.lastSleptAt,
      evolutionHistory: entity.evolutionHistory,
      history: entity.history,
      avgRoutineQuality: entity.avgRoutineQuality,
      avgHappiness: entity.avgHappiness,
      avgStress: entity.avgStress,
      avgAffection: entity.avgAffection,
      avgListeningMinutesPerDay: entity.avgListeningMinutesPerDay,
      avgStationDiversity: entity.avgStationDiversity,
      neglectScoreTeen: entity.neglectScoreTeen,
    );
  }

  /// Create from JSON map (Hive storage)
  factory TamtamaModel.fromMap(Map<String, dynamic> map) {
    final userId = map['userId'] as String?;
    if (userId == null || userId.isEmpty) {
      throw ArgumentError('userId is required');
    }

    final backgroundIndex = map['backgroundIndex'] as int?;
    final eggIndex = map['eggIndex'] as int?;
    final validBackgroundIndex = (backgroundIndex != null &&
            backgroundIndex >= 1 &&
            backgroundIndex <= totalBackgrounds)
        ? backgroundIndex
        : (Random().nextInt(totalBackgrounds) + 1);
    final validEggIndex =
        (eggIndex != null && eggIndex >= 1 && eggIndex <= totalEggs)
            ? eggIndex
            : (Random().nextInt(totalEggs) + 1);
    final rawHistory = map['history'];
    final historyMap = rawHistory is Map ? Map<String, dynamic>.from(rawHistory) : null;

    return TamtamaModel(
      userId: userId,
      petName: map['petName'] as String? ?? 'TamTama',
      backgroundIndex: validBackgroundIndex,
      eggIndex: validEggIndex,
      familyIndex: (map['familyIndex'] as int?) ?? 1,
      petId: map['petId'] as int?,
      currentFormId: map['currentFormId'] as String?,
      hunger: (map['hunger'] as num?)?.toDouble() ?? 80.0,
      energy: (map['energy'] as num?)?.toDouble() ?? 100.0,
      happiness: (map['happiness'] as num?)?.toDouble() ?? 70.0,
      hygiene: (map['hygiene'] as num?)?.toDouble() ?? 100.0,
      affection: (map['affection'] as num?)?.toDouble() ?? 30.0,
      stress: (map['stress'] as num?)?.toDouble() ?? 10.0,
      health: (map['health'] as num?)?.toDouble() ?? 100.0,
      level: (map['level'] as int?) ?? 1,
      xp: (map['xp'] as num?)?.toDouble() ?? 0.0,
      lifeStage: LifeStage.values.firstWhere(
        (e) => e.name == (map['lifeStage'] as String?),
        orElse: () => LifeStage.egg,
      ),
      petState: PetState.values.firstWhere(
        (e) => e.name == (map['petState'] as String?),
        orElse: () => PetState.idle,
      ),
      archetype: map['archetype'] != null
          ? PersonalityArchetype.values.firstWhere(
              (e) => e.name == (map['archetype'] as String),
              orElse: () => PersonalityArchetype.djStar,
            )
          : null,
      neglectScore: (map['neglectScore'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
      lastUpdateAt: DateTime.tryParse(map['lastUpdateAt'] as String? ?? '') ??
          DateTime.now(),
      lastFedAt: map['lastFedAt'] != null
          ? DateTime.tryParse(map['lastFedAt'] as String)
          : null,
      lastPlayedAt: map['lastPlayedAt'] != null
          ? DateTime.tryParse(map['lastPlayedAt'] as String)
          : null,
      lastCleanedAt: map['lastCleanedAt'] != null
          ? DateTime.tryParse(map['lastCleanedAt'] as String)
          : null,
      lastSleptAt: map['lastSleptAt'] != null
          ? DateTime.tryParse(map['lastSleptAt'] as String)
          : null,
      evolutionHistory: (map['evolutionHistory'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      history: historyMap != null ? PetHistory.fromMap(historyMap) : const PetHistory(),
      avgRoutineQuality: (map['avgRoutineQuality'] as num?)?.toDouble() ?? 0.0,
      avgHappiness: (map['avgHappiness'] as num?)?.toDouble() ?? 0.0,
      avgStress: (map['avgStress'] as num?)?.toDouble() ?? 0.0,
      avgAffection: (map['avgAffection'] as num?)?.toDouble() ?? 0.0,
      avgListeningMinutesPerDay:
          (map['avgListeningMinutesPerDay'] as num?)?.toDouble() ?? 0.0,
      avgStationDiversity:
          (map['avgStationDiversity'] as num?)?.toDouble() ?? 0.0,
      neglectScoreTeen: (map['neglectScoreTeen'] as num?)?.toDouble() ?? 0.0,
    );
  }

  static String _generateRandomPetName() {
    final names = [
      'TamTama',
      'Radio',
      'Wave',
      'Tune',
      'Beat',
      'Sound',
      'Melody',
      'Harmony',
      'Rhythm',
      'Echo',
      'Sonic',
      'Tempo',
    ];
    final random = Random();
    return names[random.nextInt(names.length)];
  }

  @override
  TamtamaModel copyWith({
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
    return TamtamaModel(
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

  /// Convert to JSON map for Hive storage
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'petName': petName,
      'backgroundIndex': backgroundIndex,
      'eggIndex': eggIndex,
      'familyIndex': familyIndex,
      'petId': petId,
      'currentFormId': currentFormId,
      'hunger': hunger,
      'energy': energy,
      'happiness': happiness,
      'hygiene': hygiene,
      'affection': affection,
      'stress': stress,
      'health': health,
      'level': level,
      'xp': xp,
      'lifeStage': lifeStage.name,
      'petState': petState.name,
      'archetype': archetype?.name,
      'neglectScore': neglectScore,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdateAt': lastUpdateAt.toIso8601String(),
      'lastFedAt': lastFedAt?.toIso8601String(),
      'lastPlayedAt': lastPlayedAt?.toIso8601String(),
      'lastCleanedAt': lastCleanedAt?.toIso8601String(),
      'lastSleptAt': lastSleptAt?.toIso8601String(),
      'evolutionHistory': evolutionHistory,
      'history': history.toMap(),
      'avgRoutineQuality': avgRoutineQuality,
      'avgHappiness': avgHappiness,
      'avgStress': avgStress,
      'avgAffection': avgAffection,
      'avgListeningMinutesPerDay': avgListeningMinutesPerDay,
      'avgStationDiversity': avgStationDiversity,
      'neglectScoreTeen': neglectScoreTeen,
    };
  }
}
