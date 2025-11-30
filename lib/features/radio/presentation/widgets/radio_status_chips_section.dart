import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/themes/design_tokens.dart';
import '../bloc/radio_player_bloc.dart';
import '../bloc/radio_player_state.dart';

class RadioStatusChipsSection extends StatelessWidget {
  const RadioStatusChipsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RadioPlayerBloc, RadioPlayerState>(
      builder: (context, state) {
        bool isPlaying = false;
        state.maybeWhen(
          ready: (playing, _, _, _, _, _, _) {
            isPlaying = playing;
          },
          orElse: () {},
        );

        return Row(
          children: [
            const _GreetingChip(),
            SizedBox(width: DesignTokens.spacingS),
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
      padding: EdgeInsets.symmetric(
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
          SizedBox(width: DesignTokens.spacingS),
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

