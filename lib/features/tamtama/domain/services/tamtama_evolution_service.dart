import 'dart:math';

import '../entities/tamtama_entity.dart';
import '../../../../core/utils/debug_logger.dart';
import 'tamtama_rng_service.dart';
import 'evolution_config_service.dart';

abstract class TamtamaEvolutionService {
  /// Checks if the pet is ready to evolve based on age and current stage
  bool shouldEvolve(TamtamaEntity pet);

  /// Determines the next stage and properties (archetype) for the pet
  /// Returns a partial TamtamaEntity with the new fields set
  TamtamaEntity evolve(TamtamaEntity pet);
  
  /// Initialize the service (load configs)
  Future<void> initialize();
}

class TamtamaEvolutionServiceImpl implements TamtamaEvolutionService {
  final EvolutionConfigService configService;
  
  // Age thresholds in hours
  static const int _hoursToHatch = 0; // Egg -> Baby (Instant/Manual)
  static const int _hoursToChild = 24; // Baby -> Child (1 day)
  static const int _hoursToTeen = 72; // Child -> Teen (3 days)
  static const int _hoursToAdult = 168; // Teen -> Adult (7 days)

  TamtamaEvolutionServiceImpl({required this.configService});
  
  @override
  Future<void> initialize() async {
    await configService.load();
  }

  @override
  bool shouldEvolve(TamtamaEntity pet) {
    if (pet.petState == PetState.evolving || pet.petState == PetState.sick) {
      return false;
    }

    final ageInHours = DateTime.now().difference(pet.createdAt).inHours;

    switch (pet.lifeStage) {
      case LifeStage.egg:
        // Egg hatching is usually manual or very quick
        return ageInHours >= _hoursToHatch;
      case LifeStage.baby:
        return ageInHours >= _hoursToChild;
      case LifeStage.child:
        return ageInHours >= _hoursToTeen;
      case LifeStage.teen:
        return ageInHours >= _hoursToAdult;
      case LifeStage.adult:
      case LifeStage.specialAdult:
        return false; // Adults don't evolve further (for now)
    }
  }

  @override
  TamtamaEntity evolve(TamtamaEntity pet) {
    final nextStage = _getNextStage(pet.lifeStage);
    PersonalityArchetype? newArchetype = pet.archetype;
    final List<String> history = List.from(pet.evolutionHistory);
    int? newPetId = pet.petId;

    // Determine archetype and pet ID when evolving to Adult
    if (nextStage == LifeStage.adult) {
      final result = _determineAdultEvolution(pet);
      newArchetype = result.archetype;
      newPetId = result.petId;
    }

    final updatedHistory = pet.history.addStage(newPetId ?? pet.petId ?? _getDefaultTeenId(pet.familyIndex));
    history.add(
      'Evolved to ${nextStage.name} on ${DateTime.now().toIso8601String()}',
    );
    if (newArchetype != null && nextStage == LifeStage.adult) {
      history.add('Archetype: ${newArchetype.name}');
    }
    
    return pet.copyWith(
      lifeStage: nextStage,
      archetype: newArchetype,
      petId: newPetId,
      evolutionHistory: history,
      petState: PetState.idle,
      history: updatedHistory,
      // Give a small boost to stats for the celebration
      happiness: min(100.0, pet.happiness + 20),
      energy: 100.0,
    );
  }

  LifeStage _getNextStage(LifeStage current) {
    switch (current) {
      case LifeStage.egg:
        return LifeStage.baby;
      case LifeStage.baby:
        return LifeStage.child;
      case LifeStage.child:
        return LifeStage.teen;
      case LifeStage.teen:
        return LifeStage.adult;
      case LifeStage.adult:
      case LifeStage.specialAdult:
        return LifeStage.adult;
    }
  }

  /// Determine adult evolution using config-driven weighted scoring
  _AdultEvolutionResult _determineAdultEvolution(TamtamaEntity pet) {
    DebugLogger.log('[Evolution] Determining Adult for ${pet.petName}');
    
    // 1. Check for hard overrides first (e.g., Voidtchi)
    for (final override in configService.hardOverrides) {
      if (override.checkCondition(pet)) {
        DebugLogger.log('[Evolution] Hard override triggered: ${override.name}');
        final archetype = PersonalityArchetype.values.firstWhere(
          (e) => e.name == override.result,
          orElse: () => PersonalityArchetype.ghostSignal,
        );
        return _AdultEvolutionResult(
          petId: override.resultId,
          archetype: archetype,
        );
      }
    }
    
    // 2. Get adult candidates for this teen
    final teenId = pet.petId ?? _getDefaultTeenId(pet.familyIndex);
    final candidates = configService.getAdultCandidates(teenId);
    
    if (candidates.isEmpty) {
      // Fallback to old behavior
      DebugLogger.log('[Evolution] No candidates found, using fallback');
      return _AdultEvolutionResult(
        petId: null,
        archetype: _fallbackArchetypeDetermination(pet),
      );
    }
    
    // 3. Calculate scores for each candidate
    final branchScores = <int, double>{};
    for (final branchId in candidates) {
      branchScores[branchId] = configService.calculateBranchScore(branchId, pet);
    }
    
    DebugLogger.log('[Evolution] Branch scores: $branchScores');
    
    // 4. Use RNG to select with noise
    final rng = TTRng.fromContext(
      userId: pet.userId,
      familyIndex: pet.familyIndex,
      stage: pet.lifeStage.index,
      installDate: pet.createdAt,
    );
    
    final selectedBranchId = rng.chooseEvolutionBranch(
      branchWeights: branchScores,
      noiseEpsilon: configService.evolutionNoiseEpsilon,
    );
    
    final archetype = configService.getArchetypeForBranch(selectedBranchId) 
        ?? PersonalityArchetype.chillLoFi;
    
    DebugLogger.log('[Evolution] Selected branch $selectedBranchId -> ${archetype.name}');
    
    return _AdultEvolutionResult(
      petId: selectedBranchId,
      archetype: archetype,
    );
  }
  
  int _getDefaultTeenId(int familyIndex) {
    // Default teen ID pattern: 14000 + (familyIndex * 10)
    return 14000 + (familyIndex * 10);
  }
  
  /// Fallback archetype determination (original logic for backwards compatibility)
  PersonalityArchetype _fallbackArchetypeDetermination(TamtamaEntity pet) {
    DebugLogger.log('[Evolution] Using fallback archetype logic');
    
    // 1. Check for Neglect/Ghost first
    if (pet.health < 20 || pet.neglectScore > 80 || pet.neglectScoreTeen > 80) {
      return PersonalityArchetype.ghostSignal;
    }

    // 2. Check for Rebel (High Stress)
    if (pet.avgStress > 70) {
      return PersonalityArchetype.rebelStatic;
    }

    // 3. Check for DJ Star (High Listening + High Happiness)
    if (pet.avgListeningMinutesPerDay > 60 && pet.avgHappiness > 70) {
      if (pet.avgListeningMinutesPerDay > 120 && pet.energy > 80) {
        return PersonalityArchetype.hyperDance;
      }
      return PersonalityArchetype.djStar;
    }

    // 4. Check for Scholar (High Discipline/Routine, Moderate Listening)
    if (pet.neglectScore < 20 && pet.avgListeningMinutesPerDay > 30) {
      return PersonalityArchetype.scholarNerd;
    }

    // 5. Check for Chill Lo-Fi (Low Stress, Moderate Happiness)
    if (pet.avgStress < 30 && pet.avgHappiness > 50) {
      return PersonalityArchetype.chillLoFi;
    }

    // 6. Check for Carebear (High Affection)
    if (pet.avgAffection > 80) {
      return PersonalityArchetype.carebearHost;
    }

    // Default Fallback
    return PersonalityArchetype.chillLoFi; 
  }
}

class _AdultEvolutionResult {
  final int? petId;
  final PersonalityArchetype archetype;
  
  _AdultEvolutionResult({
    required this.petId,
    required this.archetype,
  });
}
