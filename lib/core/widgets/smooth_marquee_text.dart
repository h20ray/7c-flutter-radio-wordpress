import 'dart:async';
import 'package:flutter/material.dart';

/// A professional marquee text widget that automatically detects overflow
/// and smoothly scrolls text with visible fade edges when needed
class SmoothMarqueeAuto extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Duration scrollDuration;
  final Duration pauseDuration;

  const SmoothMarqueeAuto({
    super.key,
    required this.text,
    this.style,
    this.scrollDuration = const Duration(seconds: 10),
    this.pauseDuration = const Duration(seconds: 2),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          textDirection: TextDirection.ltr,
        )..layout();

        final overflows = textPainter.width > constraints.maxWidth;

        if (!overflows) {
          return Text(
            text,
            style: style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        }

        return FadeMarqueeText(
          text: text,
          style: style,
          duration: scrollDuration,
        );
      },
    );
  }
}

/// A professional marquee text widget with visible fade-in/out gradients
/// Similar to Spotify, YouTube Music, and other professional music apps
class FadeMarqueeText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;

  const FadeMarqueeText({
    super.key,
    required this.text,
    this.style,
    this.duration = const Duration(seconds: 10),
  });

  @override
  State<FadeMarqueeText> createState() => _FadeMarqueeTextState();
}

class _FadeMarqueeTextState extends State<FadeMarqueeText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  Timer? _pauseTimer;
  double _textWidth = 0;
  double _totalWidth = 0;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      if (mounted) {
        _calculateWidths();
        _startMarquee();
      }
    });
  }

  @override
  void didUpdateWidget(FadeMarqueeText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text ||
        oldWidget.duration != widget.duration) {
      if (mounted) {
        _restartMarquee();
      }
    }
  }

  void _calculateWidths() {
    final textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      textDirection: TextDirection.ltr,
    )..layout();

    _textWidth = textPainter.width;
    _totalWidth = _textWidth + 50; // text width + spacing
    textPainter.dispose();
  }

  void _restartMarquee() {
    _stopMarquee();
    _controller.duration = widget.duration;
    WidgetsBinding.instance.addPostFrameCallback((duration) => _calculateWidths());
    _startMarquee();
  }

  void _startMarquee() {
    if (_isAnimating || !mounted) return;
    _isAnimating = true;
    _pauseTimer?.cancel();
    _pauseTimer = Timer(const Duration(seconds: 2), () {
      if (mounted && _isAnimating) {
        _controller.repeat();
      }
    });
  }

  void _stopMarquee() {
    _isAnimating = false;
    _pauseTimer?.cancel();
    _pauseTimer = null;
    if (_controller.isAnimating) {
      _controller.stop();
    }
    _controller.reset();
  }

  @override
  void dispose() {
    _stopMarquee();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) return const SizedBox.shrink();
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate proper height to avoid clipping descenders
        final textPainter = TextPainter(
          text: TextSpan(text: widget.text, style: widget.style),
          textDirection: TextDirection.ltr,
        )..layout();
        final textHeight = textPainter.height;
        textPainter.dispose();
        
        return ClipRect(
          child: ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.transparent,
                  Colors.black,
                  Colors.black,
                  Colors.transparent,
                ],
                stops: const [0.0, 0.05, 0.95, 1.0],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstIn,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                if (!mounted) return const SizedBox.shrink();
                return Transform.translate(
                  offset: Offset(-_animation.value * _totalWidth, 0),
                  child: child,
                );
              },
              child: SizedBox(
                height: textHeight,
                child: OverflowBox(
                  alignment: Alignment.centerLeft,
                  maxWidth: double.infinity,
                  maxHeight: textHeight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // First instance of text
                      Text(
                        widget.text,
                        style: widget.style,
                        maxLines: 1,
                        overflow: TextOverflow.visible,
                        softWrap: false,
                      ),
                      // Spacing between duplicated text
                      const SizedBox(width: 50),
                      // Second instance of text for continuous effect
                      Text(
                        widget.text,
                        style: widget.style,
                        maxLines: 1,
                        overflow: TextOverflow.visible,
                        softWrap: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

