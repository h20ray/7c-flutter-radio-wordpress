import '../../domain/entities/tamtama_entity.dart';
import '../../domain/services/pet_map_service.dart';

/// Animation types available for TamTama sprites
enum AnimationType {
  idle,     // 01
  blink,    // 02
  smile,    // 03
  sad,      // 04
  angry,    // 05
  hungry,   // 06
  eating,   // 07
  sleeping, // 08
  walking,  // 09
  evolution,// 10
  special,  // 11
  radio,    // 12
}

/// Service for resolving TamTama sprite paths.
/// 
/// Supports both:
/// - Legacy path structure: assets/sprites/tama_1baby/idle.png
/// - New numeric ID structure: assets/sprites/15011/15011_01.png
class TamtamaSpriteService {
  final PetMapService? petMapService;
  
  /// If true, prefer numeric ID-based paths. If false, use legacy paths.
  final bool useNumericIds;
  
  TamtamaSpriteService({
    this.petMapService,
    this.useNumericIds = false,
  });

  /// Returns the asset path for the pet's current state.
  String getSpritePath(TamtamaEntity pet, [AnimationType animation = AnimationType.idle]) {
    // Try numeric ID path if enabled and petId exists
    if (useNumericIds && pet.petId != null) {
      return _getNumericSpritePath(pet.petId!, animation);
    }
    
    // Fall back to legacy path structure
    return _getLegacySpritePath(pet, animation);
  }
  
  /// Get sprite path using numeric ID structure
  /// Schema: assets/sprites/{petId}/{animName}.png
  String _getNumericSpritePath(int petId, AnimationType animation) {
    final animName = _getAnimationName(animation);
    return 'assets/sprites/$petId/$animName.png';
  }
  
  /// Get animation file name from type
  String _getAnimationName(AnimationType type) {
    switch (type) {
      case AnimationType.idle:
        return 'idle';
      case AnimationType.blink:
        return 'blink';
      case AnimationType.smile:
        return 'smile';
      case AnimationType.sad:
        return 'sad';
      case AnimationType.angry:
        return 'angry';
      case AnimationType.hungry:
        return 'hungry';
      case AnimationType.eating:
        return 'eating';
      case AnimationType.sleeping:
        return 'sleeping';
      case AnimationType.walking:
        return 'walking';
      case AnimationType.evolution:
        return 'evolution';
      case AnimationType.special:
        return 'special';
      case AnimationType.radio:
        return 'radio';
    }
  }

  /// Legacy sprite path resolution (backwards compatible)
  String _getLegacySpritePath(TamtamaEntity pet, AnimationType animation) {
    // 1. Handle Egg Stage
    if (pet.lifeStage == LifeStage.egg) {
      return 'assets/sprites/eggs/egg_${pet.eggIndex}.png';
    }

    // 2. Determine base folder
    String folder;
    switch (pet.lifeStage) {
      case LifeStage.baby:
        folder = 'tama_1baby';
        break;
      case LifeStage.child:
        folder = 'tama_2child';
        break;
      case LifeStage.teen:
        folder = 'tama_3teen';
        break;
      case LifeStage.adult:
      case LifeStage.specialAdult:
        folder = 'tama_4adult';
        break;
      default:
        folder = 'tama_1baby';
    }

    // 3. Determine state suffix
    final suffix = _getAnimationSuffix(animation, pet);

    // 4. Handle Adult Archetypes
    if ((pet.lifeStage == LifeStage.adult || pet.lifeStage == LifeStage.specialAdult) 
        && pet.archetype != null) {
      return 'assets/sprites/$folder/${pet.archetype!.name}_$suffix.png';
    }

    // 5. Default generic path for non-adults
    return 'assets/sprites/$folder/$suffix.png';
  }
  
  String _getAnimationSuffix(AnimationType animation, TamtamaEntity pet) {
    // Map animation type to file suffix
    switch (animation) {
      case AnimationType.idle:
        return 'idle';
      case AnimationType.sleeping:
        return 'sleep';
      case AnimationType.eating:
        return 'eat';
      case AnimationType.radio:
        return 'listen';
      case AnimationType.evolution:
        return 'evolve';
      case AnimationType.smile:
        return 'happy';
      case AnimationType.sad:
        return 'sad';
      default:
        return 'idle';
    }
  }

  /// Returns sprite path based on current pet state
  String getSpritePathForState(TamtamaEntity pet) {
    AnimationType animation;
    
    switch (pet.petState) {
      case PetState.sleeping:
        animation = AnimationType.sleeping;
        break;
      case PetState.sick:
        animation = AnimationType.sad;
        break;
      case PetState.listening:
        animation = AnimationType.radio;
        break;
      case PetState.evolving:
        return 'assets/sprites/effects/evolve.png';
      default:
        animation = AnimationType.idle;
    }
    
    return getSpritePath(pet, animation);
  }

  /// Get the folder path for a pet's sprites
  String getSpriteFolderPath(TamtamaEntity pet) {
    if (useNumericIds && pet.petId != null) {
      return 'assets/sprites/${pet.petId}/';
    }
    
    // Legacy folder structure
    switch (pet.lifeStage) {
      case LifeStage.egg:
        return 'assets/sprites/eggs/';
      case LifeStage.baby:
        return 'assets/sprites/tama_1baby/';
      case LifeStage.child:
        return 'assets/sprites/tama_2child/';
      case LifeStage.teen:
        return 'assets/sprites/tama_3teen/';
      case LifeStage.adult:
      case LifeStage.specialAdult:
        return 'assets/sprites/tama_4adult/';
    }
  }

  /// Returns the fallback sprite path (Egg) to use if the specific sprite is missing.
  String getFallbackSpritePath() {
    return 'assets/sprites/11010/idle.png';
  }
  
  /// Get metadata file path for numeric ID pets
  String? getMetadataPath(TamtamaEntity pet) {
    if (pet.petId == null) return null;
    return 'assets/sprites/${pet.petId}/${pet.petId}.meta.json';
  }
}
