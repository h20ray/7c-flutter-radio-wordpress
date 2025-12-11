import 'package:equatable/equatable.dart';

import 'pet_action_record.dart';

class PetHistory extends Equatable {
  final List<int> stageHistory;
  final List<PetActionRecord> actions;

  const PetHistory({
    this.stageHistory = const [],
    this.actions = const [],
  });

  PetHistory addStage(int petId) {
    return PetHistory(
      stageHistory: [...stageHistory, petId],
      actions: actions,
    );
  }

  PetHistory addAction(PetActionRecord record) {
    return PetHistory(
      stageHistory: stageHistory,
      actions: [...actions, record],
    );
  }

  factory PetHistory.fromMap(Map<String, dynamic> map) {
    final stageHistory = (map['stageHistory'] as List?)?.map((e) => e as int).toList() ?? <int>[];
    final actions = (map['actions'] as List?)
            ?.map((item) => PetActionRecord.fromMap(Map<String, dynamic>.from(item as Map)))
            .toList() ??
        <PetActionRecord>[];

    return PetHistory(
      stageHistory: stageHistory,
      actions: actions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'stageHistory': stageHistory,
      'actions': actions.map((e) => e.toMap()).toList(),
    };
  }

  @override
  List<Object?> get props => [stageHistory, actions];
}
