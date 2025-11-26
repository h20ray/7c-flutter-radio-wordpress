import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../../config/game_radio_time_config.dart';
import '../../../../../core/themes/design_tokens.dart';
import '../../viewmodels/gamification_status_view_data.dart';
import '../level_animation_badge.dart';

class CurrentLevelSection extends StatelessWidget {
  final GamificationStatusViewData data;

  const CurrentLevelSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.all(DesignTokens.spacingL),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(DesignTokens.spacingXl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LevelAnimationBadge(
                size: 120,
                imageAssetPath: data.assetPath,
                animationAssetPath: data.animationAssetPath,
                backgroundColor: data.badgeBackgroundColor,
                initialLoopCount: 7,
              ),
              SizedBox(height: DesignTokens.spacingL),
              Text(
                data.levelName,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: DesignTokens.spacingS),
              Text(
                data.levelDescription,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: DesignTokens.spacingXl),
              _ListeningHoursIndicator(
                hours: data.totalListeningHours,
              ),
              SizedBox(height: DesignTokens.spacingL),
              if (!data.isMaxLevel) ...[
                _ProgressToNextLevel(
                  progress: data.progressToNextLevel,
                  nextLevelName: data.nextLevelName ?? '',
                  nextLevelTargetHours: data.nextLevelTargetHours ?? 0,
                  currentHours: data.totalListeningHours,
                ),
              ] else ...[
                _MaxLevelIndicator(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ListeningHoursIndicator extends StatelessWidget {
  final double hours;

  const _ListeningHoursIndicator({required this.hours});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final formattedHours = hours >= 100
        ? hours.toStringAsFixed(0)
        : hours.toStringAsFixed(1);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingL,
        vertical: DesignTokens.spacingM,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.timer,
            size: 20,
            color: colorScheme.primary,
          ),
          SizedBox(width: DesignTokens.spacingS),
            Text(
              'level_details_listening_hours'.tr(
                namedArgs: {'hours': formattedHours},
              ),
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
        ],
      ),
    );
  }
}

class _ProgressToNextLevel extends StatelessWidget {
  final double progress;
  final String nextLevelName;
  final double nextLevelTargetHours;
  final double currentHours;

  const _ProgressToNextLevel({
    required this.progress,
    required this.nextLevelName,
    required this.nextLevelTargetHours,
    required this.currentHours,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final hoursNeeded = (nextLevelTargetHours - currentHours).clamp(0.0, double.maxFinite);
    final formattedHoursNeeded = hoursNeeded >= 100
        ? hoursNeeded.toStringAsFixed(0)
        : hoursNeeded.toStringAsFixed(1);
    final progressColor = Color(
      GameRadioTimeConfig.resolveByHours(currentHours).badgeBackgroundColor,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'level_details_progress_to_next'.tr(),
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: DesignTokens.spacingS),
        ClipRRect(
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusProgress),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: DesignTokens.progressIndicatorHeight * 1.5,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
        ),
        SizedBox(height: DesignTokens.spacingS),
        Text(
          'level_details_hours_needed_for'.tr(
            namedArgs: {
              'hours': formattedHoursNeeded,
              'level': nextLevelName,
            },
          ),
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _MaxLevelIndicator extends StatelessWidget {
  const _MaxLevelIndicator();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(DesignTokens.spacingM),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.trophy,
            color: colorScheme.onPrimaryContainer,
            size: 20,
          ),
          SizedBox(width: DesignTokens.spacingS),
          Text(
            'level_details_max_level_reached'.tr(),
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

