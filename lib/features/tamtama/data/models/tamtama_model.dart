import 'dart:math';

import '../../domain/entities/tamtama_entity.dart';

class TamtamaModel extends TamtamaEntity {
  const TamtamaModel({
    required super.userId,
    required super.backgroundIndex,
    required super.petName,
    required super.happiness,
    required super.hunger,
    required super.level,
    required super.createdAt,
    super.lastFedAt,
    super.lastPlayedAt,
  });

  static const int totalBackgrounds = 14;

  factory TamtamaModel.initial(String userId) {
    final random = Random();
    final backgroundIndex = random.nextInt(totalBackgrounds) + 1;
    final petName = _generateRandomPetName();

    return TamtamaModel(
      userId: userId,
      backgroundIndex: backgroundIndex,
      petName: petName,
      happiness: 50,
      hunger: 50,
      level: 1,
      createdAt: DateTime.now(),
    );
  }

  factory TamtamaModel.fromEntity(TamtamaEntity entity) {
    return TamtamaModel(
      userId: entity.userId,
      backgroundIndex: entity.backgroundIndex,
      petName: entity.petName,
      happiness: entity.happiness,
      hunger: entity.hunger,
      level: entity.level,
      createdAt: entity.createdAt,
      lastFedAt: entity.lastFedAt,
      lastPlayedAt: entity.lastPlayedAt,
    );
  }

  factory TamtamaModel.fromMap(Map<String, dynamic> map) {
    final userId = map['userId'] as String?;
    if (userId == null || userId.isEmpty) {
      throw ArgumentError('userId is required');
    }

    final backgroundIndex = map['backgroundIndex'] as int?;
    final validBackgroundIndex = (backgroundIndex != null && 
        backgroundIndex >= 1 && 
        backgroundIndex <= totalBackgrounds)
        ? backgroundIndex
        : (Random().nextInt(totalBackgrounds) + 1);

    return TamtamaModel(
      userId: userId,
      backgroundIndex: validBackgroundIndex,
      petName: map['petName'] as String? ?? 'TamTama',
      happiness: (map['happiness'] as int?) ?? 50,
      hunger: (map['hunger'] as int?) ?? 50,
      level: (map['level'] as int?) ?? 1,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
      lastFedAt: map['lastFedAt'] != null
          ? DateTime.tryParse(map['lastFedAt'] as String)
          : null,
      lastPlayedAt: map['lastPlayedAt'] != null
          ? DateTime.tryParse(map['lastPlayedAt'] as String)
          : null,
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
    ];
    final random = Random();
    return names[random.nextInt(names.length)];
  }

  @override
  TamtamaModel copyWith({
    String? userId,
    int? backgroundIndex,
    String? petName,
    int? happiness,
    int? hunger,
    int? level,
    DateTime? createdAt,
    DateTime? lastFedAt,
    DateTime? lastPlayedAt,
  }) {
    return TamtamaModel(
      userId: userId ?? this.userId,
      backgroundIndex: backgroundIndex ?? this.backgroundIndex,
      petName: petName ?? this.petName,
      happiness: happiness ?? this.happiness,
      hunger: hunger ?? this.hunger,
      level: level ?? this.level,
      createdAt: createdAt ?? this.createdAt,
      lastFedAt: lastFedAt ?? this.lastFedAt,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'backgroundIndex': backgroundIndex,
      'petName': petName,
      'happiness': happiness,
      'hunger': hunger,
      'level': level,
      'createdAt': createdAt.toIso8601String(),
      'lastFedAt': lastFedAt?.toIso8601String(),
      'lastPlayedAt': lastPlayedAt?.toIso8601String(),
    };
  }
}

