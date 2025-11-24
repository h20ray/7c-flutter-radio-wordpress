import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../gamification/presentation/bloc/gamification_bloc.dart';
import '../../../gamification/presentation/viewmodels/gamification_status_view_data.dart';

class StatusGameProgressCard extends StatelessWidget {
  const StatusGameProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Transform.translate(
      offset: Offset(0, -DesignTokens.spacingXl * 1.7),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
        child: BlocBuilder<GamificationBloc, GamificationState>(
          builder: (context, state) {
            return state.maybeWhen(
              loaded: (data) => _StatusCardShell(
                colors: colors,
                child: _StatusCardBody(data: data),
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
    );
  }
}

class _StatusCardShell extends StatelessWidget {
  final AppSemanticColors colors;
  final Widget child;

  const _StatusCardShell({
    required this.colors,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.all(DesignTokens.spacingM),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
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
      children: [
        _LevelArtwork(
          assetPath: data.assetPath,
        ),
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
  final String assetPath;

  const _LevelArtwork({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
          width: 1.2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
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
      children: [
        _ListeningIndicator(
          hours: hours,
          indicatorColor: indicatorColor,
        ),
        SizedBox(height: DesignTokens.spacingXs),
        Text(
          levelName,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: DesignTokens.spacingXs),
        _ShimmerLinearProgressIndicator(
          progress: progress.clamp(0.0, 1.0),
          trackColor: Theme.of(context).colorScheme.surfaceVariant,
          fillColor: Theme.of(context).colorScheme.primary,
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
        Icon(
          LucideIcons.timer,
          size: 16,
          color: indicatorColor,
        ),
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

class _ShimmerLinearProgressIndicator extends StatefulWidget {
  final double progress;
  final Color trackColor;
  final Color fillColor;

  const _ShimmerLinearProgressIndicator({
    required this.progress,
    required this.trackColor,
    required this.fillColor,
  });

  @override
  State<_ShimmerLinearProgressIndicator> createState() =>
      _ShimmerLinearProgressIndicatorState();
}

class _ShimmerLinearProgressIndicatorState
    extends State<_ShimmerLinearProgressIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = DesignTokens.progressIndicatorHeight;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          height: height,
          width: double.infinity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final progressWidth =
                  constraints.maxWidth * widget.progress.clamp(0.0, 1.0);
              final shimmerPosition =
                  (_controller.value * (progressWidth + 60)) - 30;

              return ClipRRect(
                borderRadius:
                    BorderRadius.circular(DesignTokens.cornerRadiusProgress),
                child: Stack(
                  children: [
                    Container(
                      color: widget.trackColor,
                    ),
                    AnimatedContainer(
                      duration: DesignTokens.animationDurationShort,
                      curve: DesignTokens.animationCurveSpring,
                      width: progressWidth,
                      color: widget.fillColor,
                    ),
                    if (progressWidth > 0)
                      Positioned(
                        left: shimmerPosition.clamp(0, progressWidth),
                        width: 60,
                        top: 0,
                        bottom: 0,
                        child: IgnorePointer(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  widget.fillColor.withValues(alpha: 0.0),
                                  widget.fillColor.withValues(alpha: 0.35),
                                  widget.fillColor.withValues(alpha: 0.0),
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
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
      children: [
        _SkeletonBox(width: 220, height: 24, color: color),
        SizedBox(height: DesignTokens.spacingS),
        _SkeletonBox(width: double.infinity, height: 22, color: color),
        SizedBox(height: DesignTokens.spacingS),
        _SkeletonBox(width: double.infinity, height: 36, color: color),
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
      children: [
        Text(
          'home_status_game_title'.tr(),
          style: textTheme.titleMedium,
        ),
        SizedBox(height: DesignTokens.spacingS),
        Text(
          message,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.error,
          ),
        ),
      ],
    );
  }
}

