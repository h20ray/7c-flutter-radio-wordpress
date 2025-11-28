import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../gamification/presentation/bloc/gamification_bloc.dart';
import '../../../gamification/presentation/viewmodels/gamification_status_view_data.dart';
import '../../../gamification/presentation/widgets/level_animation_badge.dart';

class StatusGameProgressCard extends StatelessWidget {
  final bool skipWrapper;
  final VoidCallback? onTap;

  const StatusGameProgressCard({
    super.key,
    this.skipWrapper = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final navigate = onTap ??
        () => Navigator.of(context).pushNamed(AppRoutes.levelDetails);

    final child = Padding(
      padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
        child: InkWell(
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
          onTap: navigate,
          child: BlocBuilder<GamificationBloc, GamificationState>(
            builder: (context, state) {
              return state.maybeWhen(
                loaded: (data) => _StatusCardShell(
                  colors: colors,
                  child: _StatusCardBody(
                    data: data,
                    onArtworkTap: navigate,
                  ),
                ),
                error: (failure) => _StatusCardShell(
                  colors: colors,
                  child: _StatusCardError(message: failure.message),
                ),
                orElse: () => _StatusCardShell(
                  colors: colors,
                  child: const _StatusCardSkeleton(),
                ),
              );
            },
          ),
        ),
      ),
    );

    if (skipWrapper) {
      return child;
    }

    return Transform.translate(
      offset: Offset(0, -DesignTokens.spacingXl * 1.7),
      child: child,
    );
  }
}

class _StatusCardShell extends StatelessWidget {
  final AppSemanticColors colors;
  final Widget child;

  const _StatusCardShell({required this.colors, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.all(DesignTokens.spacingM),
      constraints: const BoxConstraints(minHeight: 68),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
      ),
      child: child,
    );
  }
}

class _StatusCardBody extends StatelessWidget {
  final GamificationStatusViewData data;
  final VoidCallback? onArtworkTap;

  const _StatusCardBody({
    required this.data,
    this.onArtworkTap,
  });

  @override
  Widget build(BuildContext context) {
    final indicatorColor = Theme.of(context).colorScheme.onSurface;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LevelAnimationBadge(
          size: 68,
          imageAssetPath: data.assetPath,
          animationAssetPath: data.animationAssetPath,
          backgroundColor: data.badgeBackgroundColor,
          onTap: onArtworkTap,
        ),
        SizedBox(width: DesignTokens.spacingL),
        Expanded(
          child: _LevelMetadata(
            hours: data.totalListeningHours,
            levelName: data.levelName,
            progress: data.progressToNextLevel,
            isMaxLevel: data.isMaxLevel,
            indicatorColor: indicatorColor,
            progressColor: Color(data.badgeBackgroundColor),
          ),
        ),
        SizedBox(width: DesignTokens.spacingS),
        Icon(
          LucideIcons.chevron_right,
          size: 20,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }
}

class _LevelMetadata extends StatelessWidget {
  final double hours;
  final String levelName;
  final double progress;
  final bool isMaxLevel;
  final Color indicatorColor;
  final Color progressColor;

  const _LevelMetadata({
    required this.hours,
    required this.levelName,
    required this.progress,
    required this.isMaxLevel,
    required this.indicatorColor,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _ListeningIndicator(hours: hours, indicatorColor: indicatorColor),
        SizedBox(height: 2),
        Flexible(
          child: Text(
            levelName,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: 2),
        if (isMaxLevel)
          _MaxLevelPill()
        else
          _MaterialProgressIndicator(
            progress: progress.clamp(0.0, 1.0),
            color: progressColor,
          ),
      ],
    );
  }
}

class _ListeningIndicator extends StatelessWidget {
  final double hours;
  final Color indicatorColor;

  const _ListeningIndicator({
    required this.hours,
    required this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    final formattedHours = hours >= 100
        ? hours.toStringAsFixed(0)
        : hours.toStringAsFixed(1);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(LucideIcons.timer, size: 16, color: indicatorColor),
        SizedBox(width: DesignTokens.spacingXs),
        Text(
          '$formattedHours h',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: indicatorColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _StatusCardSkeleton extends StatelessWidget {
  const _StatusCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _SkeletonBox(width: 220, height: 16, color: color),
        SizedBox(height: 2),
        _SkeletonBox(width: double.infinity, height: 16, color: color),
        SizedBox(height: 2),
        _SkeletonBox(width: double.infinity, height: 28, color: color),
      ],
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class _StatusCardError extends StatelessWidget {
  final String message;

  const _StatusCardError({required this.message});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'home_status_game_title'.tr(),
          style: textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: DesignTokens.spacingXs),
        Text(
          message,
          style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _MaxLevelPill extends StatelessWidget {
  const _MaxLevelPill();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingXs + 2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.trophy,
            size: 10,
            color: colorScheme.onPrimaryContainer,
          ),
          SizedBox(width: 3),
          Text(
            'level_details_max_level_reached'.tr(),
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _MaterialProgressIndicator extends StatelessWidget {
  final double progress;
  final Color color;

  const _MaterialProgressIndicator({
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: progress),
      duration: DesignTokens.animationDurationMedium,
      curve: DesignTokens.animationCurveDefault,
      builder: (context, value, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(
            DesignTokens.cornerRadiusProgress,
          ),
          child: LinearProgressIndicator(
            value: value,
            minHeight: DesignTokens.progressIndicatorHeight,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        );
      },
    );
  }
}
