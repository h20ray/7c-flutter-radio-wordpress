import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../config/radio_config.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/themes/component_tokens.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/widgets/haptic_widgets.dart';
import '../../../../core/utils/haptic_feedback_helper.dart';

class RadioMenuChipsSection extends StatelessWidget {
  const RadioMenuChipsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final menuChips = <Widget>[];

    if (RadioConfig.showLyrics) {
      menuChips.add(
        _MenuChip(
          icon: LucideIcons.music,
          label: 'radio_menu_lyrics',
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.lyrics);
          },
        ),
      );
    }

    if (RadioConfig.showRequest) {
      menuChips.add(
        _MenuChip(
          icon: LucideIcons.send,
          label: 'radio_menu_request',
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.request);
          },
        ),
      );
    }

    if (RadioConfig.showAbout) {
      menuChips.add(
        _MenuChip(
          icon: LucideIcons.info,
          label: 'radio_menu_about',
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.radioAbout);
          },
        ),
      );
    }

    if (RadioConfig.showSongHistory) {
      menuChips.add(
        _MenuChip(
          icon: LucideIcons.history,
          label: 'radio_menu_song_history',
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.songHistory);
          },
        ),
      );
    }

    return Row(
      children: [
        const _GreetingChip(),
        if (menuChips.isNotEmpty) ...[
          SizedBox(width: DesignTokens.spacingS),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: menuChips
                    .expand((chip) => [
                          chip,
                          SizedBox(width: DesignTokens.spacingS),
                        ])
                    .take(menuChips.length * 2 - 1)
                    .toList(),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _MenuChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ModeTabsTokens.of(context);
    final theme = Theme.of(context);

    return HapticGestureDetector(
      hapticType: HapticFeedbackType.selectionClick,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingS,
          vertical: DesignTokens.spacingS,
        ),
        decoration: BoxDecoration(
          color: tokens.unselectedBackground,
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusPill),
          border: Border.all(
            color: tokens.unselectedText.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: tokens.unselectedText,
            ),
            SizedBox(width: DesignTokens.spacingXs),
            Text(
              label.tr(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: tokens.unselectedText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GreetingChip extends StatelessWidget {
  const _GreetingChip();

  double _getContrastRatio(Color foreground, Color background) {
    final fgLuminance = _getLuminance(foreground);
    final bgLuminance = _getLuminance(background);
    final lighter = fgLuminance > bgLuminance ? fgLuminance : bgLuminance;
    final darker = fgLuminance > bgLuminance ? bgLuminance : fgLuminance;
    return (lighter + 0.05) / (darker + 0.05);
  }

  double _getLuminance(Color color) {
    final r = color.r;
    final g = color.g;
    final b = color.b;

    final rLinear = r <= 0.03928 ? r / 12.92 : math.pow((r + 0.055) / 1.055, 2.4);
    final gLinear = g <= 0.03928 ? g / 12.92 : math.pow((g + 0.055) / 1.055, 2.4);
    final bLinear = b <= 0.03928 ? b / 12.92 : math.pow((b + 0.055) / 1.055, 2.4);

    return 0.2126 * rLinear + 0.7152 * gLinear + 0.0722 * bLinear;
  }

  Color _getGreetingColor(BuildContext context, String greetingKey) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    switch (greetingKey) {
      case 'greeting_morning':
        return isDark
            ? const Color(0xFFFFD54F)
            : const Color(0xFFFFF176);
      case 'greeting_midday':
        return isDark
            ? const Color(0xFFFF9800)
            : const Color(0xFFFFB74D);
      case 'greeting_evening':
        return isDark
            ? const Color(0xFFFF6F00)
            : const Color(0xFFFF8A65);
      case 'greeting_night':
        return isDark
            ? const Color(0xFF212121)
            : const Color(0xFF616161);
      default:
        return theme.colorScheme.surfaceContainerHighest;
    }
  }

  Color _getGreetingTextColor(BuildContext context, String greetingKey) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = _getGreetingColor(context, greetingKey);

    Color getTextColor(Color bgColor, {required bool isDarkMode}) {
      final lightText = isDarkMode ? Colors.white : const Color(0xFF212121);
      final darkText = isDarkMode ? const Color(0xFF212121) : Colors.white;

      final lightContrast = _getContrastRatio(lightText, bgColor);
      final darkContrast = _getContrastRatio(darkText, bgColor);

      return lightContrast >= 4.5
          ? lightText
          : darkContrast >= 4.5
              ? darkText
              : lightContrast > darkContrast
                  ? lightText
                  : darkText;
    }

    switch (greetingKey) {
      case 'greeting_morning':
        return getTextColor(backgroundColor, isDarkMode: isDark);
      case 'greeting_midday':
        return getTextColor(backgroundColor, isDarkMode: isDark);
      case 'greeting_evening':
        return getTextColor(backgroundColor, isDarkMode: isDark);
      case 'greeting_night':
        return Colors.white;
      default:
        return theme.colorScheme.onSurface;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hour = DateTime.now().hour;
    String greetingKey;
    if (hour >= 4 && hour < 11) {
      greetingKey = 'greeting_morning';
    } else if (hour >= 11 && hour < 15) {
      greetingKey = 'greeting_midday';
    } else if (hour >= 15 && hour < 18) {
      greetingKey = 'greeting_evening';
    } else {
      greetingKey = 'greeting_night';
    }

    final chipColor = _getGreetingColor(context, greetingKey);
    final textColor = _getGreetingTextColor(context, greetingKey);

    final borderColor = textColor.withValues(alpha: 0.15);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingS,
        vertical: DesignTokens.spacingS,
      ),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusPill),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Text(
        greetingKey.tr(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: textColor,
          letterSpacing: DesignTokens.letterSpacingLabelSmall,
        ),
      ),
    );
  }
}

