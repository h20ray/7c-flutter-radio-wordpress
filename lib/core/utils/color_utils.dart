import 'dart:math' as math;
import 'package:flutter/material.dart';

class ColorUtils {
  static double getLuminance(Color color) {
    final r = color.r;
    final g = color.g;
    final b = color.b;

    final rLinear = r <= 0.03928
        ? r / 12.92
        : math.pow((r + 0.055) / 1.055, 2.4);
    final gLinear = g <= 0.03928
        ? g / 12.92
        : math.pow((g + 0.055) / 1.055, 2.4);
    final bLinear = b <= 0.03928
        ? b / 12.92
        : math.pow((b + 0.055) / 1.055, 2.4);

    return 0.2126 * rLinear + 0.7152 * gLinear + 0.0722 * bLinear;
  }

  static double getContrastRatio(Color foreground, Color background) {
    final fgLuminance = getLuminance(foreground);
    final bgLuminance = getLuminance(background);
    final lighter = fgLuminance > bgLuminance ? fgLuminance : bgLuminance;
    final darker = fgLuminance > bgLuminance ? bgLuminance : fgLuminance;
    return (lighter + 0.05) / (darker + 0.05);
  }

  static Color getOptimalTextColor(
    Color backgroundColor, {
    required bool isDarkMode,
  }) {
    const minContrastRatio = 4.5;
    final lightText = isDarkMode ? Colors.white : const Color(0xFF212121);
    final darkText = isDarkMode ? const Color(0xFF212121) : Colors.white;

    final lightContrast = getContrastRatio(lightText, backgroundColor);
    final darkContrast = getContrastRatio(darkText, backgroundColor);

    return lightContrast >= minContrastRatio
        ? lightText
        : darkContrast >= minContrastRatio
            ? darkText
            : lightContrast > darkContrast
                ? lightText
                : darkText;
  }
}

