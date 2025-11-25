import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../gamification/presentation/bloc/gamification_bloc.dart';
import '../../../gamification/presentation/viewmodels/gamification_status_view_data.dart';

class StatusGameProgressCard extends StatelessWidget {
  final bool skipWrapper;

  const StatusGameProgressCard({super.key, this.skipWrapper = false});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final content = Padding(
      padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
      child: BlocBuilder<GamificationBloc, GamificationState>(
        builder: (context, state) {
          return state.maybeWhen(
            loaded: (data) => _StatusCardShell(
              colors: colors,
              child: _TappableStatusCardBody(data: data),
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
    );

    if (skipWrapper) {
      return content;
    }

    return Transform.translate(
      offset: Offset(0, -DesignTokens.spacingXl * 1.7),
      child: content,
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

class _TappableStatusCardBody extends StatelessWidget {
  final GamificationStatusViewData data;

  const _TappableStatusCardBody({required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.levelDetails);
      },
      borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
      child: _StatusCardBody(data: data),
    );
  }
}

class _StatusCardBody extends StatelessWidget {
  final GamificationStatusViewData data;

  const _StatusCardBody({required this.data});

  @override
  Widget build(BuildContext context) {
    final indicatorColor = Theme.of(context).colorScheme.onSurface;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _LevelArtwork(size: 68, assetPath: data.assetPath),
        SizedBox(width: DesignTokens.spacingL),
        Expanded(
          child: _LevelMetadata(
            hours: data.totalListeningHours,
            levelName: data.levelName,
            progress: data.progressToNextLevel,
            indicatorColor: indicatorColor,
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

class _LevelArtwork extends StatelessWidget {
  final double size;
  final String assetPath;

  const _LevelArtwork({required this.size, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.25),
            width: 1.2,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            assetPath,
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _LevelMetadata extends StatelessWidget {
  final double hours;
  final String levelName;
  final double progress;
  final Color indicatorColor;

  const _LevelMetadata({
    required this.hours,
    required this.levelName,
    required this.progress,
    required this.indicatorColor,
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
        _MaterialProgressIndicator(
          progress: progress.clamp(0.0, 1.0),
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

class _MaterialProgressIndicator extends StatelessWidget {
  final double progress;

  const _MaterialProgressIndicator({required this.progress});

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
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
          ),
        );
      },
    );
  }
}
