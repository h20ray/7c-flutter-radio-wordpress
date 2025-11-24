import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../themes/app_color_system.dart';
import '../themes/component_tokens.dart';
import '../themes/design_tokens.dart';
import '../../features/radio/presentation/bloc/radio_player_bloc.dart';
import '../../features/radio/presentation/bloc/radio_player_event.dart';
import '../../features/radio/presentation/bloc/radio_player_state.dart';

class FloatingPlayFab extends StatefulWidget {
  final double size;

  const FloatingPlayFab({
    super.key,
    this.size = 56,
  });

  @override
  State<FloatingPlayFab> createState() => _FloatingPlayFabState();
}

class _FloatingPlayFabState extends State<FloatingPlayFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final colors = context.appColors;

    return BlocBuilder<RadioPlayerBloc, RadioPlayerState>(
      builder: (context, state) {
        final isPlaying = state.maybeWhen(
          ready:
              (
                playing,
                currentUrl,
                currentArtist,
                currentTitle,
                currentAlbumArtUrl,
                isDucking,
                canAutoResume,
              ) => playing,
          orElse: () => false,
        );

        if (isPlaying) {
          _pulseController.forward();
        } else {
          _pulseController.stop();
          _pulseController.reset();
        }

        final borderRadius = BorderRadius.circular(widget.size / 3);
        final shadows = AppShadowTokens.of(context);

        return AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            final fabBackground = isPlaying
                ? colors.advanced.primaryFixedDim
                : colorScheme.primary;
            final fabForeground = isPlaying
                ? colors.advanced.onPrimaryFixed
                : colorScheme.onPrimary;

            return Transform.scale(
              scale: isPlaying ? _pulseAnimation.value : 1.0,
              child: SizedBox(
                height: widget.size,
                width: widget.size,
                child: AnimatedContainer(
                  duration: DesignTokens.animationDurationMedium,
                  curve: DesignTokens.animationCurveSpring,
                  decoration: BoxDecoration(
                    color: fabBackground,
                    borderRadius: borderRadius,
                    boxShadow: [
                      BoxShadow(
                        color: shadows.level2,
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: borderRadius,
                    child: InkWell(
                      borderRadius: borderRadius,
                      onTap: () {
                        context.read<RadioPlayerBloc>().add(
                          const RadioPlayerEvent.togglePlayPause(),
                        );
                      },
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: DesignTokens.animationDurationShort,
                          switchInCurve: DesignTokens.animationCurveSpring,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(
                                scale: Tween(begin: 0.9, end: 1.0)
                                    .animate(animation),
                                child: child,
                              ),
                            );
                          },
                        child: Icon(
                          isPlaying ? LucideIcons.pause : LucideIcons.play,
                            key: ValueKey<bool>(isPlaying),
                          size: 28,
                            color: fabForeground,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
