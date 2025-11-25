import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'design_tokens.dart';

class LinearIndicatorThemeData
    extends ThemeExtension<LinearIndicatorThemeData> {
  const LinearIndicatorThemeData({
    required this.barHeight,
    required this.animationDuration,
    required this.animationCurve,
    required this.trackColor,
    required this.activeColor,
    required this.thumbColor,
    required this.thumbBorderColor,
    required this.enableShimmer,
  });

  factory LinearIndicatorThemeData.fromScheme(ColorScheme scheme) {
    final isLight = scheme.brightness == Brightness.light;
    final trackOpacity = isLight ? 0.14 : 0.28;
    return LinearIndicatorThemeData(
      barHeight: DesignTokens.progressIndicatorHeight,
      animationDuration: DesignTokens.animationDurationShort,
      animationCurve: DesignTokens.animationCurveSpring,
      trackColor: scheme.onSurface.withValues(alpha: trackOpacity),
      activeColor: scheme.primary,
      thumbColor: scheme.primary,
      thumbBorderColor: scheme.onPrimary.withValues(alpha: 0.24),
      enableShimmer: true,
    );
  }

  final double barHeight;
  final Duration animationDuration;
  final Curve animationCurve;
  final Color trackColor;
  final Color activeColor;
  final Color thumbColor;
  final Color thumbBorderColor;
  final bool enableShimmer;

  @override
  LinearIndicatorThemeData copyWith({
    double? barHeight,
    Duration? animationDuration,
    Curve? animationCurve,
    Color? trackColor,
    Color? activeColor,
    Color? thumbColor,
    Color? thumbBorderColor,
    bool? enableShimmer,
  }) {
    return LinearIndicatorThemeData(
      barHeight: barHeight ?? this.barHeight,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      trackColor: trackColor ?? this.trackColor,
      activeColor: activeColor ?? this.activeColor,
      thumbColor: thumbColor ?? this.thumbColor,
      thumbBorderColor: thumbBorderColor ?? this.thumbBorderColor,
      enableShimmer: enableShimmer ?? this.enableShimmer,
    );
  }

  @override
  LinearIndicatorThemeData lerp(
    covariant ThemeExtension<LinearIndicatorThemeData>? other,
    double t,
  ) {
    if (other is! LinearIndicatorThemeData) {
      return this;
    }
    return LinearIndicatorThemeData(
      barHeight: lerpDouble(barHeight, other.barHeight, t) ?? barHeight,
      animationDuration:
          _lerpDuration(animationDuration, other.animationDuration, t),
      animationCurve: t < 0.5 ? animationCurve : other.animationCurve,
      trackColor: Color.lerp(trackColor, other.trackColor, t)!,
      activeColor: Color.lerp(activeColor, other.activeColor, t)!,
      thumbColor: Color.lerp(thumbColor, other.thumbColor, t)!,
      thumbBorderColor:
          Color.lerp(thumbBorderColor, other.thumbBorderColor, t)!,
      enableShimmer: t < 0.5 ? enableShimmer : other.enableShimmer,
    );
  }

  static Duration _lerpDuration(Duration a, Duration b, double t) {
    final microseconds =
        (a.inMicroseconds + (b.inMicroseconds - a.inMicroseconds) * t)
            .round();
    return Duration(microseconds: microseconds);
  }
}

extension LinearIndicatorThemeX on ThemeData {
  LinearIndicatorThemeData get linearIndicatorTheme =>
      extension<LinearIndicatorThemeData>() ??
      LinearIndicatorThemeData.fromScheme(colorScheme);
}

