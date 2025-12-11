import 'package:equatable/equatable.dart';

enum PetActionType {
  feed,
  play,
  clean,
  sleep,
  wake,
  tick,
  listening,
  evolution,
}

class PetActionRecord extends Equatable {
  final PetActionType type;
  final DateTime timestamp;
  final Map<String, double> deltas;

  const PetActionRecord({
    required this.type,
    required this.timestamp,
    this.deltas = const {},
  });

  factory PetActionRecord.fromMap(Map<String, dynamic> map) {
    final rawType = map['type'] as String?;
    final type = PetActionType.values.firstWhere(
      (value) => value.name == rawType,
      orElse: () => PetActionType.tick,
    );

    final rawTimestamp = map['timestamp'] as String?;
    final timestamp = DateTime.tryParse(rawTimestamp ?? '') ?? DateTime.now();

    final deltas = (map['deltas'] as Map?)?.map(
          (key, value) => MapEntry(key as String, (value as num).toDouble()),
        ) ??
        <String, double>{};

    return PetActionRecord(
      type: type,
      timestamp: timestamp,
      deltas: deltas,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'deltas': deltas,
    };
  }

  PetActionRecord copyWith({
    PetActionType? type,
    DateTime? timestamp,
    Map<String, double>? deltas,
  }) {
    return PetActionRecord(
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      deltas: deltas ?? this.deltas,
    );
  }

  @override
  List<Object?> get props => [type, timestamp, deltas];
}
