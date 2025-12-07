import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/smooth_marquee_text.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../config/radio_config.dart';
import '../bloc/radio_player_bloc.dart';
import '../bloc/radio_player_state.dart';

class RadioMetadataSection extends StatelessWidget {
  const RadioMetadataSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final subtitleColor = theme.colorScheme.onSurfaceVariant;

    return BlocBuilder<RadioPlayerBloc, RadioPlayerState>(
      builder: (context, state) {
        String? title;
        String? artist;
        bool isPlaying = false;

        state.maybeWhen(
          ready: (playing, currentUrl, currentArtist, currentTitle,
              currentAlbumArtUrl, isDucking, canAutoResume) {
            title = currentTitle;
            artist = currentArtist;
            isPlaying = playing;
          },
          orElse: () {},
        );

        final normalizedTitle = title?.trim().isNotEmpty == true
            ? title!.trim()
            : RadioConfig.fallbackTitle;
        final normalizedArtist = artist?.trim().isNotEmpty == true
            ? artist!.trim()
            : RadioConfig.fallbackArtist;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: SmoothMarqueeAuto(
                      key: ValueKey(normalizedTitle),
                      text: normalizedTitle,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                      ),
                      scrollDuration: const Duration(seconds: 12),
                      pauseDuration: const Duration(seconds: 3),
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: SmoothMarqueeAuto(
                      key: ValueKey(normalizedArtist),
                      text: normalizedArtist,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: subtitleColor,
                        fontWeight: FontWeight.w400,
                      ),
                      scrollDuration: const Duration(seconds: 10),
                      pauseDuration: const Duration(seconds: 3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: DesignTokens.spacingM),
            _LiveChip(isActive: isPlaying),
          ],
        );
      },
    );
  }
}

class _LiveChip extends StatelessWidget {
  final bool isActive;

  const _LiveChip({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final indicatorColor = theme.colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingS,
        vertical: DesignTokens.spacingS,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusPill),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LiveIndicatorDot(isActive: isActive, color: indicatorColor),
          const SizedBox(width: DesignTokens.spacingS),
          Text(
            'LIVE',
            style: theme.textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveIndicatorDot extends StatefulWidget {
  final bool isActive;
  final Color color;

  const _LiveIndicatorDot({
    required this.isActive,
    required this.color,
  });

  @override
  State<_LiveIndicatorDot> createState() => _LiveIndicatorDotState();
}

class _LiveIndicatorDotState extends State<_LiveIndicatorDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _breathing;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _breathing = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    if (widget.isActive) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant _LiveIndicatorDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive) {
      if (widget.isActive) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _createActiveIndicatorColor(Color baseColor) {
    final brightness = ThemeData.estimateBrightnessForColor(baseColor);
    if (brightness == Brightness.dark) {
      return const Color(0xFF4CAF50);
    } else {
      return const Color(0xFF66BB6A);
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.isActive
        ? _createActiveIndicatorColor(widget.color)
        : widget.color.withValues(alpha: 0.4);

    return AnimatedBuilder(
      animation: _breathing,
      builder: (context, child) {
        final scale = widget.isActive ? 0.9 + _breathing.value * 0.25 : 1.0;
        final glowOpacity = widget.isActive
            ? 0.3 + _breathing.value * 0.4
            : 0.0;
        return Container(
          width: 12,
          height: 12,
          alignment: Alignment.center,
          child: Container(
            width: 8 * scale,
            height: 8 * scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: baseColor,
              boxShadow: widget.isActive
                  ? [
                      BoxShadow(
                        color: baseColor.withValues(alpha: glowOpacity),
                        blurRadius: 12 * scale,
                        spreadRadius: 1.5 * scale,
                      ),
                    ]
                  : null,
            ),
          ),
        );
      },
    );
  }
}

