import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tujuhcahaya_wprs/core/themes/app_theme.dart';
import 'package:tujuhcahaya_wprs/core/themes/component_tokens.dart';

double _contrastRatio(Color foreground, Color background) {
  final fg = foreground.computeLuminance();
  final bg = background.computeLuminance();
  final brightest = fg > bg ? fg : bg;
  final darkest = fg > bg ? bg : fg;
  return (brightest + 0.05) / (darkest + 0.05);
}

void main() {
  testWidgets('Home header tokens keep readable contrast in light theme',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Builder(
          builder: (context) {
            final tokens = HomeHeaderTokens.of(context);
            final gradientBase = tokens.backgroundStart;
            expect(_contrastRatio(tokens.primaryText, gradientBase), greaterThan(3));
            expect(
              _contrastRatio(tokens.secondaryText, gradientBase),
              greaterThan(2),
            );
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  });

  testWidgets('News card tokens keep CTA legible on accent surfaces',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Builder(
          builder: (context) {
            final tokens = NewsCardTokens.of(context);
            expect(
              _contrastRatio(tokens.ctaText, tokens.ctaBackground),
              greaterThan(3),
            );
            expect(
              _contrastRatio(tokens.badgeText, tokens.badgeBackground),
              greaterThan(2),
            );
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  });
}

