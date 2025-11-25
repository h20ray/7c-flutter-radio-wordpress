import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tujuhcahaya_wprs/features/home/presentation/widgets/animated_game_progress.dart';

void main() {
  group('AnimatedGameProgress', () {
    testWidgets('animates smoothly toward the target progress',
        (tester) async {
      final snapshots = <double>[];

      await tester.pumpWidget(
        MaterialApp(
          home: AnimatedGameProgress(
            progress: 0.8,
            enableShimmer: true,
            onProgressChanged: snapshots.add,
          ),
        ),
      );

      await tester.pump(); // start animation
      await tester.pump(const Duration(milliseconds: 200));
      expect(snapshots.last, greaterThan(0.1));

      await tester.pumpAndSettle();
      expect(snapshots.last, closeTo(0.8, 0.01));
    });

    testWidgets('respects disableAnimations MediaQuery flag', (tester) async {
      final snapshots = <double>[];

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: AnimatedGameProgress(
              progress: 0.55,
              enableShimmer: false,
              onProgressChanged: snapshots.add,
            ),
          ),
        ),
      );

      await tester.pump();
      expect(snapshots, isNotEmpty);
      expect(snapshots.last, equals(0.55));
    });
  });
}

