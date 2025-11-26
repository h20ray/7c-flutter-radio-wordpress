import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../../config/game_radio_time_config.dart';
import '../../../../../core/themes/app_color_system.dart';
import '../../../../../core/themes/design_tokens.dart';
import '../level_animation_badge.dart';

class LevelCardItem extends StatelessWidget {
  final GameLevelDefinition level;
  final bool isCurrent;
  final bool isUnlocked;
  final bool isMaxLevel;
  final double currentHours;

  const LevelCardItem({
    super.key,
    required this.level,
    required this.isCurrent,
    required this.isUnlocked,
    required this.isMaxLevel,
    required this.currentHours,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    Color cardBackgroundColor;
    if (isCurrent) {
      cardBackgroundColor = colorScheme.primaryContainer.withValues(alpha: 0.3);
    } else if (isUnlocked) {
      final baseColor = Color(level.badgeBackgroundColor);
      cardBackgroundColor = _lightenColor(baseColor, 0.2);
    } else {
      cardBackgroundColor = colors.cardBackground;
    }

    return Card(
      color: cardBackgroundColor,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
        child: isUnlocked
            ? Padding(
                padding: EdgeInsets.all(DesignTokens.spacingL),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LevelAnimationBadge(
                      size: 64,
                      imageAssetPath: level.assetPath,
                      animationAssetPath: level.animationAssetPath,
                      backgroundColor: level.badgeBackgroundColor,
                      initialLoopCount: 0,
                      enableAnimation: isUnlocked,
                      isLocked: !isUnlocked,
                    ),
                    SizedBox(width: DesignTokens.spacingL),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  level.displayName,
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: isCurrent
                                        ? colorScheme.onPrimaryContainer
                                        : _getTextColorForVibrantBackground(
                                            level.id),
                                  ),
                                ),
                              ),
                              if (isCurrent) ...[
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: DesignTokens.spacingS,
                                    vertical: DesignTokens.spacingXs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary,
                                    borderRadius: BorderRadius.circular(
                                      DesignTokens.cornerRadiusPill,
                                    ),
                                  ),
                                  child: Text(
                                    'level_details_current'.tr(),
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ] else if (isUnlocked && !isCurrent) ...[
                                Icon(
                                  LucideIcons.check,
                                  size: 20,
                                  color: _getTextColorForVibrantBackground(
                                      level.id),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: DesignTokens.spacingXs),
                          Text(
                            level.description,
                            style: textTheme.bodySmall?.copyWith(
                              color: isCurrent
                                  ? colorScheme.onSurfaceVariant
                                  : _getTextColorForVibrantBackground(level.id)
                                      .withValues(alpha: 0.8),
                            ),
                          ),
                          SizedBox(height: DesignTokens.spacingM),
                          _LevelRequirements(
                            level: level,
                            isUnlocked: isUnlocked,
                            isCurrent: isCurrent,
                            isMaxLevel: isMaxLevel,
                            currentHours: currentHours,
                            textColor: isCurrent
                                ? colorScheme.onSurfaceVariant
                                : _getTextColorForVibrantBackground(level.id)
                                    .withValues(alpha: 0.9),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.1),
                  padding: EdgeInsets.all(DesignTokens.spacingL),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LevelAnimationBadge(
                        size: 64,
                        imageAssetPath: level.assetPath,
                        animationAssetPath: level.animationAssetPath,
                        backgroundColor: level.badgeBackgroundColor,
                        initialLoopCount: 0,
                        enableAnimation: false,
                        isLocked: true,
                      ),
                      SizedBox(width: DesignTokens.spacingL),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '???',
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: colorScheme.onSurfaceVariant
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: DesignTokens.spacingXs),
                            Text(
                              'level_details_locked'.tr(),
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.5),
                              ),
                            ),
                            SizedBox(height: DesignTokens.spacingM),
                            _LevelRequirements(
                              level: level,
                              isUnlocked: false,
                              isCurrent: false,
                              isMaxLevel: false,
                              currentHours: currentHours,
                              textColor: colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.6),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Color _getTextColorForVibrantBackground(String levelId) {
    return const Color(0xFF1A1A1A);
  }

  Color _lightenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final lighter =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
    return lighter;
  }
}

class _LevelRequirements extends StatelessWidget {
  final GameLevelDefinition level;
  final bool isUnlocked;
  final bool isCurrent;
  final bool isMaxLevel;
  final double currentHours;
  final Color textColor;

  const _LevelRequirements({
    required this.level,
    required this.isUnlocked,
    required this.isCurrent,
    required this.isMaxLevel,
    required this.currentHours,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (isMaxLevel && isCurrent) {
      return Text(
        'level_details_max_status'.tr(),
        style: textTheme.labelSmall?.copyWith(
          color: textColor,
        ),
      );
    }

    if (level.isMaxLevel && !isCurrent) {
      return Row(
        children: [
          Icon(
            LucideIcons.infinity,
            size: 16,
            color: textColor,
          ),
          SizedBox(width: DesignTokens.spacingXs),
          Text(
            'level_details_hours_minimum'.tr(
              namedArgs: {'hours': level.minHours.toStringAsFixed(0)},
            ),
            style: textTheme.labelSmall?.copyWith(
              color: textColor,
            ),
          ),
        ],
      );
    }

    if (isCurrent) {
      return const SizedBox.shrink();
    }

    final shouldShowLockedMessage = !isUnlocked || isCurrent;
    if (!shouldShowLockedMessage) {
      return const SizedBox.shrink();
    }

    final hoursNeeded =
        (level.minHours - currentHours).clamp(0.0, double.maxFinite);
    final formattedHoursNeeded = hoursNeeded >= 100
        ? hoursNeeded.toStringAsFixed(0)
        : hoursNeeded.toStringAsFixed(1);

    return Row(
      children: [
        Icon(
          LucideIcons.lock,
          size: 16,
          color: textColor,
        ),
        SizedBox(width: DesignTokens.spacingXs),
        Flexible(
          child: Text(
            'level_details_hours_needed_to_unlock'.tr(
              namedArgs: {'hours': formattedHoursNeeded},
            ),
            style: textTheme.labelSmall?.copyWith(
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }
}

