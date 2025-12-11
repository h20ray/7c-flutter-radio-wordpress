import '../entities/tamtama_entity.dart';

/// Lightweight data model for TamTama home screen widget display.
/// 
/// This contains only the essential data needed for the native widget
/// to render the pet state without the full entity complexity.
class TamtamaWidgetData {
  /// Pet's display name
  final String petName;
  
  /// Numeric pet ID for sprite resolution (e.g., 11010, 15011)
  final int petId;
  
  /// Current life stage as string for native code
  final String lifeStage;
  
  /// Hunger stat (0.0 - 100.0)
  final double hunger;
  
  /// Happiness stat (0.0 - 100.0)
  final double happiness;
  
  /// Energy stat (0.0 - 100.0)
  final double energy;
  
  /// Current level (1-50)
  final int level;
  
  /// Whether the pet needs immediate attention
  final bool needsAttention;
  
  /// Path to the current sprite image
  final String spritePath;
  
  /// Timestamp of last update
  final DateTime lastUpdated;

  const TamtamaWidgetData({
    required this.petName,
    required this.petId,
    required this.lifeStage,
    required this.hunger,
    required this.happiness,
    required this.energy,
    required this.level,
    required this.needsAttention,
    required this.spritePath,
    required this.lastUpdated,
  });

  /// Create widget data from a full TamTama entity
  factory TamtamaWidgetData.fromEntity(TamtamaEntity entity, String spritePath) {
    return TamtamaWidgetData(
      petName: entity.petName,
      petId: entity.petId ?? 11010, // Default to egg if no petId
      lifeStage: entity.lifeStage.name,
      hunger: entity.hunger,
      happiness: entity.happiness,
      energy: entity.energy,
      level: entity.level,
      needsAttention: entity.needsAttention,
      spritePath: spritePath,
      lastUpdated: DateTime.now(),
    );
  }

  /// Serialize to Map for SharedPreferences/UserDefaults
  Map<String, dynamic> toJson() {
    return {
      'pet_name': petName,
      'pet_id': petId,
      'life_stage': lifeStage,
      'hunger': hunger,
      'happiness': happiness,
      'energy': energy,
      'level': level,
      'needs_attention': needsAttention,
      'sprite_path': spritePath,
      'last_updated': lastUpdated.millisecondsSinceEpoch,
    };
  }

  /// Deserialize from Map
  factory TamtamaWidgetData.fromJson(Map<String, dynamic> json) {
    return TamtamaWidgetData(
      petName: json['pet_name'] as String? ?? 'TamTama',
      petId: json['pet_id'] as int? ?? 11010,
      lifeStage: json['life_stage'] as String? ?? 'egg',
      hunger: (json['hunger'] as num?)?.toDouble() ?? 100.0,
      happiness: (json['happiness'] as num?)?.toDouble() ?? 100.0,
      energy: (json['energy'] as num?)?.toDouble() ?? 100.0,
      level: json['level'] as int? ?? 1,
      needsAttention: json['needs_attention'] as bool? ?? false,
      spritePath: json['sprite_path'] as String? ?? '',
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(
        json['last_updated'] as int? ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  @override
  String toString() {
    return 'TamtamaWidgetData(petName: $petName, petId: $petId, '
        'level: $level, needsAttention: $needsAttention)';
  }
}
