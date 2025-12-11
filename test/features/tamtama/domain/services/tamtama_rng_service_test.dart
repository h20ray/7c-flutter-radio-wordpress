import 'package:flutter_test/flutter_test.dart';

import 'package:tujuhcahaya_wprs/features/tamtama/domain/services/tamtama_rng_service.dart';

void main() {
  group('TTRng', () {
    test('computeSeed is deterministic for same input', () {
      final seedA = TTRng.computeSeed(
        userId: 'user-1',
        familyIndex: 1,
        stage: 2,
        installDate: DateTime.utc(2024, 1, 1),
      );
      final seedB = TTRng.computeSeed(
        userId: 'user-1',
        familyIndex: 1,
        stage: 2,
        installDate: DateTime.utc(2024, 1, 1),
      );

      expect(seedA, seedB);
    });

    test('chooseEvolutionBranch selects highest weight when noise is zero', () {
      final rng = TTRng(12345);
      final branch = rng.chooseEvolutionBranch(
        branchWeights: {
          15011: 0.2,
          15012: 0.8,
          15013: 0.1,
        },
        noiseEpsilon: 0,
      );

      expect(branch, 15012);
    });
  });
}
