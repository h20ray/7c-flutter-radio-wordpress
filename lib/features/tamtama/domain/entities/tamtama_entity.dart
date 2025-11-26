import 'package:equatable/equatable.dart';

class TamtamaEntity extends Equatable {
  final String userId;
  final int backgroundIndex;
  final int eggIndex;
  final String petName;
  final int happiness;
  final int hunger;
  final int level;
  final DateTime createdAt;
  final DateTime? lastFedAt;
  final DateTime? lastPlayedAt;

  const TamtamaEntity({
    required this.userId,
    required this.backgroundIndex,
    required this.eggIndex,
    required this.petName,
    required this.happiness,
    required this.hunger,
    required this.level,
    required this.createdAt,
    this.lastFedAt,
    this.lastPlayedAt,
  });

  bool get isHungry => hunger < 50;
  bool get isHappy => happiness >= 70;
  bool get needsAttention => hunger < 30 || happiness < 30;

  TamtamaEntity copyWith({
    String? userId,
    int? backgroundIndex,
    int? eggIndex,
    String? petName,
    int? happiness,
    int? hunger,
    int? level,
    DateTime? createdAt,
    DateTime? lastFedAt,
    DateTime? lastPlayedAt,
  }) {
    return TamtamaEntity(
      userId: userId ?? this.userId,
      backgroundIndex: backgroundIndex ?? this.backgroundIndex,
      eggIndex: eggIndex ?? this.eggIndex,
      petName: petName ?? this.petName,
      happiness: happiness ?? this.happiness,
      hunger: hunger ?? this.hunger,
      level: level ?? this.level,
      createdAt: createdAt ?? this.createdAt,
      lastFedAt: lastFedAt ?? this.lastFedAt,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        backgroundIndex,
        eggIndex,
        petName,
        happiness,
        hunger,
        level,
        createdAt,
        lastFedAt,
        lastPlayedAt,
      ];
}

