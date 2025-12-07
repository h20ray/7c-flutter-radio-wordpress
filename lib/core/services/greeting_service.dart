import 'package:flutter/material.dart';
import '../utils/color_utils.dart';

class GreetingService {
  static String getGreetingKey() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 11) {
      return 'greeting_morning';
    } else if (hour >= 11 && hour < 15) {
      return 'greeting_midday';
    } else if (hour >= 15 && hour < 18) {
      return 'greeting_evening';
    } else {
      return 'greeting_night';
    }
  }

  static Color getGreetingColor(BuildContext context, String greetingKey) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    switch (greetingKey) {
      case 'greeting_morning':
        return isDark ? const Color(0xFFFFD54F) : const Color(0xFFFFF176);
      case 'greeting_midday':
        return isDark ? const Color(0xFFFF9800) : const Color(0xFFFFB74D);
      case 'greeting_evening':
        return isDark ? const Color(0xFFFF6F00) : const Color(0xFFFF8A65);
      case 'greeting_night':
        return isDark ? const Color(0xFF212121) : const Color(0xFF616161);
      default:
        return theme.colorScheme.surfaceContainerHighest;
    }
  }

  static Color getGreetingTextColor(BuildContext context, String greetingKey) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = getGreetingColor(context, greetingKey);

    switch (greetingKey) {
      case 'greeting_morning':
      case 'greeting_midday':
      case 'greeting_evening':
        return ColorUtils.getOptimalTextColor(
          backgroundColor,
          isDarkMode: isDark,
        );
      case 'greeting_night':
        return Colors.white;
      default:
        return theme.colorScheme.onSurface;
    }
  }
}

