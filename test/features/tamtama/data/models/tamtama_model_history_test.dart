import 'package:flutter_test/flutter_test.dart';

import 'package:tujuhcahaya_wprs/features/tamtama/data/models/tamtama_model.dart';
import 'package:tujuhcahaya_wprs/features/tamtama/domain/entities/pet_action_record.dart';
import 'package:tujuhcahaya_wprs/features/tamtama/domain/entities/pet_history.dart';
import 'package:tujuhcahaya_wprs/features/tamtama/domain/entities/tamtama_entity.dart';

void main() {
  test('TamtamaModel preserves history through map conversion', () {
    final history = PetHistory(
      stageHistory: const [11010, 12010],
      actions: [
        PetActionRecord(
          type: PetActionType.feed,
          timestamp: DateTime.utc(2024, 1, 1),
          deltas: const {'hunger': 10},
        ),
      ],
    );

    final model = TamtamaModel(
      userId: 'u1',
      petName: 'Tama',
      backgroundIndex: 1,
      eggIndex: 1,
      familyIndex: 1,
      petId: 11010,
      hunger: 50,
      energy: 60,
      happiness: 70,
      hygiene: 80,
      affection: 10,
      stress: 5,
      health: 90,
      level: 1,
      xp: 0,
      lifeStage: LifeStage.egg,
      petState: PetState.idle,
      neglectScore: 0,
      createdAt: DateTime.utc(2024, 1, 1),
      lastUpdateAt: DateTime.utc(2024, 1, 1),
      history: history,
    );

    final mapped = model.toMap();
    final restored = TamtamaModel.fromMap(mapped);

    expect(restored.history.stageHistory, [11010, 12010]);
    expect(restored.history.actions.first.type, PetActionType.feed);
    expect(restored.history.actions.first.deltas['hunger'], 10);
  });
}
