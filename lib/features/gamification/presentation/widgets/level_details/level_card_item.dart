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
  final double currentHours;

  const LevelCardItem({
    super.key,
    required this.level,
    required this.isCurrent,
    required this.isUnlocked,
    required this.currentHours,
  });

  Color _getCardBackgroundColor(BuildContext context) {
    final colors = context.appColors;
    final colorScheme = Theme.of(context).colorScheme;

    if (isCurrent) {
      return colorScheme.primaryContainer.withValues(alpha: 0.3);
    }
    if (isUnlocked) {
      final baseColor = Color(level.badgeBackgroundColor);
      final hsl = HSLColor.fromColor(baseColor);
      return hsl.withLightness((hsl.lightness + 0.2).clamp(0.0, 1.0)).toColor();
    }
    return colors.cardBackground;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _getCardBackgroundColor(context),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
      ),
      child: isUnlocked ? _buildUnlockedContent(context) : _buildLockedContent(context),
    );
  }

  Widget _buildUnlockedContent(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
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
                              : const Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    if (isCurrent)
                      _buildCurrentBadge(context)
                    else if (isUnlocked)
                      const Icon(
                        LucideIcons.check,
                        size: 20,
                        color: Color(0xFF1A1A1A),
                      ),
                  ],
                ),
                SizedBox(height: DesignTokens.spacingXs),
                Text(
                  level.description,
                  style: textTheme.bodySmall?.copyWith(
                    color: isCurrent
                        ? colorScheme.onSurfaceVariant
                        : const Color(0xFF1A1A1A).withValues(alpha: 0.8),
                  ),
                ),
                SizedBox(height: DesignTokens.spacingM),
                _LevelRequirements(
                  level: level,
                  isUnlocked: isUnlocked,
                  isCurrent: isCurrent,
                  currentHours: currentHours,
                  textColor: isCurrent
                      ? colorScheme.onSurfaceVariant
                      : const Color(0xFF1A1A1A).withValues(alpha: 0.9),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockedContent(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: Colors.black.withValues(alpha: 0.15),
      padding: EdgeInsets.all(DesignTokens.spacingL),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              LevelAnimationBadge(
                size: 64,
                imageAssetPath: level.assetPath,
                animationAssetPath: level.animationAssetPath,
                backgroundColor: null,
                initialLoopCount: 0,
                enableAnimation: false,
                isLocked: true,
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    LucideIcons.lock,
                    size: 24,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: DesignTokens.spacingL),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Text(
                    level.displayName,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentBadge(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingS,
        vertical: DesignTokens.spacingXs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusPill),
      ),
      child: Text(
        'level_details_current'.tr(),
        style: textTheme.labelSmall?.copyWith(
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _LevelRequirements extends StatelessWidget {
  final GameLevelDefinition level;
  final bool isUnlocked;
  final bool isCurrent;
  final double currentHours;
  final Color textColor;

  const _LevelRequirements({
    required this.level,
    required this.isUnlocked,
    required this.isCurrent,
    required this.currentHours,
    required this.textColor,
  });

  bool get _isMaxLevel => level.isMaxLevel && isCurrent;

  String _formatTimeRemaining(double hours) {
    if (hours < 1.0) {
      final minutes = (hours * 60).round();
      return minutes.toString();
    }
    return hours >= 100
        ? hours.toStringAsFixed(0)
        : hours.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (_isMaxLevel) {
      return Text(
        'level_details_max_status'.tr(),
        style: textTheme.labelSmall?.copyWith(color: textColor),
      );
    }

    if (level.isMaxLevel && !isCurrent) {
      return Row(
        children: [
          Icon(LucideIcons.infinity, size: 16, color: textColor),
          SizedBox(width: DesignTokens.spacingXs),
          Text(
            'level_details_hours_minimum'.tr(
              namedArgs: {'hours': level.minHours.toStringAsFixed(0)},
            ),
            style: textTheme.labelSmall?.copyWith(color: textColor),
          ),
        ],
      );
    }

    if (isCurrent || isUnlocked) {
      return const SizedBox.shrink();
    }

    final hoursNeeded = (level.minHours - currentHours).clamp(0.0, double.maxFinite);
    final timeValue = _formatTimeRemaining(hoursNeeded);
    final isMinutes = hoursNeeded < 1.0;

    return Row(
      children: [
        Icon(LucideIcons.lock, size: 16, color: textColor),
        SizedBox(width: DesignTokens.spacingXs),
        Flexible(
          child: Text(
            isMinutes
                ? 'level_details_minutes_needed_to_unlock'.tr(
                    namedArgs: {'minutes': timeValue},
                  )
                : 'level_details_hours_needed_to_unlock'.tr(
                    namedArgs: {'hours': timeValue},
                  ),
            style: textTheme.labelSmall?.copyWith(color: textColor),
          ),
        ),
      ],
    );
  }
}

