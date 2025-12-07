import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/themes/design_tokens.dart';

class RadioLiveIndicator extends StatefulWidget {
  final bool isActive;
  final Color textColor;
  final Color indicatorColor;

  const RadioLiveIndicator({
    super.key,
    required this.isActive,
    this.textColor = Colors.white,
    this.indicatorColor = Colors.white,
  });

  @override
  State<RadioLiveIndicator> createState() => _RadioLiveIndicatorState();
}

class _RadioLiveIndicatorState extends State<RadioLiveIndicator>
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
  void didUpdateWidget(covariant RadioLiveIndicator oldWidget) {
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
        ? _createActiveIndicatorColor(widget.indicatorColor)
        : widget.indicatorColor.withValues(alpha: 0.4);

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

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
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
        ),
        const SizedBox(width: DesignTokens.spacingS),
        Text(
          'LIVE',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: widget.textColor,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(width: DesignTokens.spacingM),
        Text(
          greetingKey.tr(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: widget.textColor.withValues(alpha: 0.7),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

