import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../config/radio_config.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/themes/component_tokens.dart';
import '../../../../core/themes/design_tokens.dart';

class RadioMenuChipsSection extends StatelessWidget {
  const RadioMenuChipsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final menuChips = <Widget>[];

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

    return GestureDetector(
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
                fontWeight: FontWeight.w600,
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

  Color _getGreetingColor(BuildContext context, String greetingKey) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    switch (greetingKey) {
      case 'greeting_morning':
        return isDark
            ? const Color(0xFFFFE082)
            : const Color(0xFFFFF9C4);
      case 'greeting_midday':
        return isDark
            ? const Color(0xFFFFB74D)
            : const Color(0xFFFFE0B2);
      case 'greeting_evening':
        return isDark
            ? const Color(0xFFFF8A65)
            : const Color(0xFFFFCCBC);
      case 'greeting_night':
        return isDark
            ? const Color(0xFF424242)
            : const Color(0xFF757575);
      default:
        return theme.colorScheme.surfaceContainerHighest;
    }
  }

  Color _getGreetingTextColor(BuildContext context, String greetingKey) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    switch (greetingKey) {
      case 'greeting_morning':
        return isDark
            ? const Color(0xFFF57F17)
            : const Color(0xFFF9A825);
      case 'greeting_midday':
        return isDark
            ? const Color(0xFFE65100)
            : const Color(0xFFEF6C00);
      case 'greeting_evening':
        return isDark
            ? const Color(0xFFD84315)
            : const Color(0xFFE64A19);
      case 'greeting_night':
        return isDark
            ? Colors.white70
            : Colors.white;
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

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingS,
        vertical: DesignTokens.spacingS,
      ),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusPill),
        border: Border.all(
          color: textColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Text(
        greetingKey.tr(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

