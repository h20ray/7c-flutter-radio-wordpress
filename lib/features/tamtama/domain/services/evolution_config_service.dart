import 'dart:convert';

import 'package:flutter/services.dart';

import '../entities/tamtama_entity.dart';
import '../../../../core/utils/debug_logger.dart';

/// Configuration for a pet family's evolution tree
class FamilyConfig {
  final int familyIndex;
  final List<int> eggs;
  final int baby;
  final int child;
  final int teen;
  final List<int> adults;
  final List<int> specials;

  const FamilyConfig({
    required this.familyIndex,
    required this.eggs,
    required this.baby,
    required this.child,
    required this.teen,
    required this.adults,
    required this.specials,
  });

  factory FamilyConfig.fromJson(Map<String, dynamic> json) {
    final ids = json['ids'] as Map<String, dynamic>;
    return FamilyConfig(
      familyIndex: json['familyIndex'] as int,
      eggs: (ids['eggs'] as List).cast<int>(),
      baby: ids['baby'] as int,
      child: ids['child'] as int,
      teen: ids['teen'] as int,
      adults: (ids['adults'] as List).cast<int>(),
      specials: (ids['specials'] as List).cast<int>(),
    );
  }

  /// Get the pet ID for a given stage
  int? getPetIdForStage(LifeStage stage, {int variant = 0}) {
    switch (stage) {
      case LifeStage.egg:
        return variant < eggs.length ? eggs[variant] : eggs.first;
      case LifeStage.baby:
        return baby;
      case LifeStage.child:
        return child;
      case LifeStage.teen:
        return teen;
      case LifeStage.adult:
      case LifeStage.specialAdult:
        return variant < adults.length ? adults[variant] : adults.first;
    }
  }
}

/// Scoring formula weights for adult branch selection
class BranchScoringFormula {
  final int branchId;
  final String archetype;
  final Map<String, double> weights;

  const BranchScoringFormula({
    required this.branchId,
    required this.archetype,
    required this.weights,
  });

  factory BranchScoringFormula.fromJson(int id, Map<String, dynamic> json) {
    return BranchScoringFormula(
      branchId: id,
      archetype: json['archetype'] as String? ?? 'chillLoFi',
      weights: (json['weights'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, (v as num).toDouble()),
      ),
    );
  }
}

/// Hard override condition for special evolution triggers
class HardOverride {
  final String name;
  final Map<String, dynamic> condition;
  final String result;
  final int resultId;

  const HardOverride({
    required this.name,
    required this.condition,
    required this.result,
    required this.resultId,
  });

  factory HardOverride.fromJson(Map<String, dynamic> json) {
    return HardOverride(
      name: json['name'] as String,
      condition: json['condition'] as Map<String, dynamic>,
      result: json['result'] as String,
      resultId: json['resultId'] as int,
    );
  }

  /// Check if this override condition is met
  bool checkCondition(TamtamaEntity pet) {
    for (final entry in condition.entries) {
      final field = entry.key;
      final constraint = entry.value as Map<String, dynamic>;
      
      final petValue = _getFieldValue(pet, field);
      if (petValue == null) continue;

      // Check gte (greater than or equal)
      if (constraint.containsKey('gte')) {
        final threshold = (constraint['gte'] as num).toDouble();
        if (petValue < threshold) return false;
      }

      // Check lte (less than or equal)
      if (constraint.containsKey('lte')) {
        final threshold = (constraint['lte'] as num).toDouble();
        if (petValue > threshold) return false;
      }
    }
    return true;
  }

  double? _getFieldValue(TamtamaEntity pet, String field) {
    switch (field) {
      case 'neglectScoreTeen':
        return pet.neglectScoreTeen;
      case 'avgAffection':
        return pet.avgAffection;
      case 'avgHappiness':
        return pet.avgHappiness;
      case 'avgStress':
        return pet.avgStress;
      case 'health':
        return pet.health;
      case 'neglectScore':
        return pet.neglectScore;
      default:
        return null;
    }
  }
}

/// Service for loading and accessing evolution configuration
class EvolutionConfigService {
  static const String _configPath = 'assets/config/evolution.json';

  Map<String, FamilyConfig>? _families;
  Map<String, List<int>>? _teenToAdultCandidates;
  Map<int, BranchScoringFormula>? _scoringFormulas;
  List<HardOverride>? _hardOverrides;
  double _evolutionNoiseEpsilon = 0.05;
  int _maxStreakDays = 10;
  int _targetListenMinutesPerDay = 90;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  double get evolutionNoiseEpsilon => _evolutionNoiseEpsilon;
  int get maxStreakDays => _maxStreakDays;
  int get targetListenMinutesPerDay => _targetListenMinutesPerDay;

  /// Load configuration from assets
  Future<void> load() async {
    if (_isLoaded) return;

    try {
      final jsonString = await rootBundle.loadString(_configPath);
      final json = jsonDecode(jsonString) as Map<String, dynamic>;

      // Parse meta
      final meta = json['meta'] as Map<String, dynamic>?;
      if (meta != null) {
        _evolutionNoiseEpsilon = (meta['evolutionNoiseEpsilon'] as num?)?.toDouble() ?? 0.05;
        _maxStreakDays = (meta['maxStreakDays'] as int?) ?? 10;
        _targetListenMinutesPerDay = (meta['targetListenMinutesPerDay'] as int?) ?? 90;
      }

      // Parse families
      final familiesJson = json['families'] as Map<String, dynamic>? ?? {};
      _families = familiesJson.map(
        (key, value) => MapEntry(key, FamilyConfig.fromJson(value as Map<String, dynamic>)),
      );

      // Parse teen to adult candidates
      final candidatesJson = json['youngToAdultCandidates'] as Map<String, dynamic>? ?? {};
      _teenToAdultCandidates = candidatesJson.map(
        (key, value) => MapEntry(key, (value as List).cast<int>()),
      );

      // Parse scoring formulas
      final formulasJson = json['scoringFormulas'] as Map<String, dynamic>? ?? {};
      _scoringFormulas = {};
      for (final entry in formulasJson.entries) {
        final id = int.tryParse(entry.key);
        if (id != null) {
          _scoringFormulas![id] = BranchScoringFormula.fromJson(id, entry.value as Map<String, dynamic>);
        }
      }

      // Parse hard overrides
      final overridesJson = json['hardOverrides'] as List? ?? [];
      _hardOverrides = overridesJson
          .map((e) => HardOverride.fromJson(e as Map<String, dynamic>))
          .toList();

      _isLoaded = true;
      DebugLogger.log('[EvolutionConfig] Loaded ${_families?.length ?? 0} families, ${_scoringFormulas?.length ?? 0} formulas');

    } catch (e, stackTrace) {
      DebugLogger.logError('[EvolutionConfig] Failed to load: $e', stackTrace: stackTrace);
      // Initialize with empty defaults
      _families = {};
      _teenToAdultCandidates = {};
      _scoringFormulas = {};
      _hardOverrides = [];
      _isLoaded = true;
    }
  }

  /// Get family config by index (1-7)
  FamilyConfig? getFamily(int familyIndex) {
    final key = 'family${familyIndex.toString().padLeft(2, '0')}';
    return _families?[key];
  }

  /// Get all families
  List<FamilyConfig> get allFamilies => _families?.values.toList() ?? [];

  /// Get adult candidates for a teen pet ID
  List<int> getAdultCandidates(int teenId) {
    return _teenToAdultCandidates?[teenId.toString()] ?? [];
  }

  /// Get scoring formula for a branch ID
  BranchScoringFormula? getScoringFormula(int branchId) {
    return _scoringFormulas?[branchId];
  }

  /// Get all hard overrides
  List<HardOverride> get hardOverrides => _hardOverrides ?? [];

  /// Calculate weighted score for a branch given pet stats
  double calculateBranchScore(int branchId, TamtamaEntity pet) {
    final formula = getScoringFormula(branchId);
    if (formula == null) return 0.0;

    double score = 0.0;
    for (final entry in formula.weights.entries) {
      final weightKey = entry.key;
      final weight = entry.value;
      final fieldValue = _getPetStatForKey(pet, weightKey);
      score += fieldValue * weight;
    }
    return score;
  }

  double _getPetStatForKey(TamtamaEntity pet, String key) {
    // Normalize to 0-1 range for consistent weighting
    switch (key) {
      case 'L': // avgListeningMinutesPerDay
        return (pet.avgListeningMinutesPerDay / _targetListenMinutesPerDay).clamp(0.0, 1.0);
      case 'S': // avgStress (lower is better, so invert)
        return 1.0 - (pet.avgStress / 100.0);
      case 'H': // avgHappiness
        return pet.avgHappiness / 100.0;
      case 'R': // avgRoutineQuality
        return pet.avgRoutineQuality.clamp(0.0, 1.0);
      case 'A': // avgAffection
        return pet.avgAffection / 100.0;
      case 'D': // avgStationDiversity
        return (pet.avgStationDiversity / 10.0).clamp(0.0, 1.0);
      case 'T_inv': // neglectScoreTeenInverse
        return 1.0 - (pet.neglectScoreTeen / 100.0);
      default:
        return 0.0;
    }
  }

  /// Get the archetype enum for a branch ID
  PersonalityArchetype? getArchetypeForBranch(int branchId) {
    final formula = getScoringFormula(branchId);
    if (formula == null) return null;

    return PersonalityArchetype.values.firstWhere(
      (e) => e.name == formula.archetype,
      orElse: () => PersonalityArchetype.chillLoFi,
    );
  }
}
