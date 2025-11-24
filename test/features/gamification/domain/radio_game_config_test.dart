import 'package:flutter_test/flutter_test.dart';

import 'package:tujuhcahaya_wprs/config/radio_config.dart';

void main() {
  group('RadioGameConfig', () {
    test('resolves correct level based on hours', () {
      // Arrange
      final samples = {
        0.0: RadioGameLevel.level1FrequencyWanderer,
        9.9: RadioGameLevel.level1FrequencyWanderer,
        10.0: RadioGameLevel.level2ActiveTuner,
        29.9: RadioGameLevel.level2ActiveTuner,
        30.0: RadioGameLevel.level3StudioCompanion,
        59.9: RadioGameLevel.level3StudioCompanion,
        60.0: RadioGameLevel.level4AirwaveCitizen,
        119.9: RadioGameLevel.level4AirwaveCitizen,
        120.0: RadioGameLevel.level5RadioStar,
        249.9: RadioGameLevel.level5RadioStar,
        250.0: RadioGameLevel.level6BroadcastLegend,
      };

      // Act & Assert
      samples.forEach((hours, expectedLevel) {
        final definition = RadioGameConfig.resolveByHours(hours);
        expect(definition.level, expectedLevel);
      });
    });

    test('progress reaches full when at max level', () {
      // Arrange
      const hours = 400.0;

      // Act
      final progress = RadioGameConfig.progressToNextLevel(hours);
      final nextLevel = RadioGameConfig.nextLevel(
        RadioGameLevel.level6BroadcastLegend,
      );

      // Assert
      expect(progress, 1);
      expect(nextLevel, isNull);
    });
  });
}

