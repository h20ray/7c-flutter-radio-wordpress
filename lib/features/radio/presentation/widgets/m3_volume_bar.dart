import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class M3VolumeBar extends StatefulWidget {
  const M3VolumeBar({
    super.key,
    required this.value,            // 0.0 – 1.0
    required this.onChanged,
    this.wavyActive = true,
    this.waveStrength = 0.4,        // 0.0..1.0
    this.height,                    // content bar height (not touch target)
    this.semanticLabel = 'Volume',
    this.steps,                     // e.g., 21 for 5% steps
    this.enableHaptics = true,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final bool wavyActive;
  final double waveStrength;
  final double? height;
  final String semanticLabel;
  final int? steps;
  final bool enableHaptics;

  @override
  State<M3VolumeBar> createState() => _M3VolumeBarState();
}

class _M3VolumeBarState extends State<M3VolumeBar> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late double _visualValue; // tweened value for smoothness
  Timer? _animationTimer;

  @override
  void initState() {
    super.initState();
    _visualValue = widget.value.clamp(0.0, 1.0);
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only start animation if shimmer is active and animations are enabled
    if (widget.wavyActive && _shouldAnimate()) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant M3VolumeBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Check if animation state should change
    final shouldAnimate = widget.wavyActive && _shouldAnimate();
    if (shouldAnimate && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!shouldAnimate && _controller.isAnimating) {
      _controller.stop();
    }
    
    _animateTo(widget.value.clamp(0.0, 1.0));
  }

  bool _shouldAnimate() {
    return MediaQuery.maybeOf(context)?.disableAnimations != true && TickerMode.of(context);
  }

  void _animateTo(double target) {
    final begin = _visualValue;
    if ((begin - target).abs() < 0.001) {
      _visualValue = target;
      return;
    }
    
    // Cancel any existing animation timer
    _animationTimer?.cancel();
    
    // Use a more efficient animation approach
    final startTime = DateTime.now();
    const duration = Duration(milliseconds: 140);
    
    _animationTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      final elapsed = DateTime.now().difference(startTime);
      final progress = (elapsed.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
      
      if (progress >= 1.0) {
        _visualValue = target;
        timer.cancel();
        if (mounted) setState(() {});
      } else {
        // Use easeOutCubic curve
        final easedProgress = 1 - (1 - progress) * (1 - progress) * (1 - progress);
        _visualValue = begin + (target - begin) * easedProgress;
        if (mounted) setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  double _snapIfNeeded(double v) {
    if (widget.steps == null || widget.steps! <= 1) return v;
    final step = 1.0 / (widget.steps! - 1);
    return (v / step).round() * step;
  }

  void _maybeHaptic(double oldV, double newV) {
    if (!widget.enableHaptics || widget.steps == null) return;
    final step = 1.0 / (widget.steps! - 1);
    final oldStep = (oldV / step).round();
    final newStep = (newV / step).round();
    if (oldStep != newStep) HapticFeedback.selectionClick();
  }

  void _updateFromDx(double dx, double width, TextDirection dir) {
    width = width.clamp(1.0, double.infinity);
    dx = dx.clamp(0.0, width);
    double v = (dx / width).clamp(0.0, 1.0);
    if (dir == TextDirection.rtl) v = 1.0 - v;
    final snapped = _snapIfNeeded(v);
    _maybeHaptic(widget.value, snapped);
    widget.onChanged(snapped);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dir = Directionality.of(context);
    final trackColor = theme.colorScheme.onSurface.withValues(alpha: 0.12);

    final double barHeight = (widget.height ?? 4.0).clamp(2.0, 12.0);
    final BorderRadius radius = BorderRadius.circular(barHeight / 2);

    final bool shouldAnimate = _shouldAnimate() && widget.wavyActive;
    if (shouldAnimate && !_controller.isAnimating) {
      _controller.repeat();
    }
    if (!shouldAnimate && _controller.isAnimating) {
      _controller.stop();
    }

    return FocusableActionDetector(
      autofocus: false,
      actions: <Type, Action<Intent>>{
        _IncreaseIntent: CallbackAction<_IncreaseIntent>(onInvoke: (_) {
          final delta = widget.steps != null ? (1.0 / (widget.steps! - 1)) : 0.05;
          final next = _snapIfNeeded((widget.value + delta).clamp(0.0, 1.0));
          widget.onChanged(next);
          if (widget.enableHaptics) HapticFeedback.selectionClick();
          return null;
        }),
        _DecreaseIntent: CallbackAction<_DecreaseIntent>(onInvoke: (_) {
          final delta = widget.steps != null ? (1.0 / (widget.steps! - 1)) : 0.05;
          final next = _snapIfNeeded((widget.value - delta).clamp(0.0, 1.0));
          widget.onChanged(next);
          if (widget.enableHaptics) HapticFeedback.selectionClick();
          return null;
        }),
        _JumpStartIntent: CallbackAction<_JumpStartIntent>(onInvoke: (_) {
          widget.onChanged(_snapIfNeeded(0.0));
          return null;
        }),
        _JumpEndIntent: CallbackAction<_JumpEndIntent>(onInvoke: (_) {
          widget.onChanged(_snapIfNeeded(1.0));
          return null;
        }),
      },
      shortcuts: <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.arrowLeft):  _DecreaseIntent(),
        SingleActivator(LogicalKeyboardKey.arrowRight): _IncreaseIntent(),
        SingleActivator(LogicalKeyboardKey.home): _JumpStartIntent(),
        SingleActivator(LogicalKeyboardKey.end): _JumpEndIntent(),
      },
      child: Semantics(
        label: widget.semanticLabel,
        value: '${(widget.value * 100).round()}%',
        increasedValue: widget.steps != null ? 'Increase' : null,
        decreasedValue: widget.steps != null ? 'Decrease' : null,
        onIncrease: () {
          final delta = widget.steps != null ? (1.0 / (widget.steps! - 1)) : 0.05;
          final next = _snapIfNeeded((widget.value + delta).clamp(0.0, 1.0));
          widget.onChanged(next);
        },
        onDecrease: () {
          final delta = widget.steps != null ? (1.0 / (widget.steps! - 1)) : 0.05;
          final next = _snapIfNeeded((widget.value - delta).clamp(0.0, 1.0));
          widget.onChanged(next);
        },
        slider: true,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Material(
              type: MaterialType.transparency,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragUpdate: (d) => _updateFromDx(d.localPosition.dx, constraints.maxWidth, dir),
                onTapDown: (d) => _updateFromDx(d.localPosition.dx, constraints.maxWidth, dir),
                child: InkWell(
                  customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onTap: () {}, // keep ripple
                  child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 48, minWidth: 48, maxHeight: 48),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: radius,
                      child: SizedBox(
                        height: barHeight,
                        width: double.infinity,
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, _) {
                            return CustomPaint(
                              painter: _M3LinearProgressPainter(
                                progress: _visualValue.clamp(0.0, 1.0),
                                barHeight: barHeight,
                                activeColor: theme.colorScheme.primary,
                                trackColor: trackColor,
                                thumbColor: theme.colorScheme.primary,
                                borderColor: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
                                shimmerPhase: _controller.value,
                                enableShimmer: widget.wavyActive,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            );
          },
        ),
      ),
    );
  }
}

class _M3LinearProgressPainter extends CustomPainter {
  _M3LinearProgressPainter({
    required this.progress,
    required this.barHeight,
    required this.activeColor,
    required this.trackColor,
    required this.thumbColor,
    required this.borderColor,
    required this.shimmerPhase,
    required this.enableShimmer,
  });

  final double progress;
  final double barHeight;
  final Color activeColor;
  final Color trackColor;
  final Color thumbColor;
  final Color borderColor;
  final double shimmerPhase;
  final bool enableShimmer;

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final radius = Radius.circular(barHeight / 2);

    // Draw full inactive track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = barHeight
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    canvas.drawLine(Offset(0, centerY), Offset(size.width, centerY), trackPaint);

    // Active segment width
    final activeW = (size.width * progress).clamp(0.0, size.width);

    // Draw active segment
    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = barHeight
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    if (activeW > 0) {
      canvas.drawLine(Offset(0, centerY), Offset(activeW, centerY), activePaint);
    }

    // Draw shimmer if enabled and active segment wide enough
    if (enableShimmer && activeW > 8) {
      // Make shimmer proportionally wide so it looks like a smooth light sweep
      final desiredWidth = size.width * 0.35;
      final sw = desiredWidth.clamp(0.0, activeW).clamp(0.0, 56.0); // 35% of total width, max 56px, not wider than activeW
      final offset = (shimmerPhase % 1.0) * (activeW + sw) - sw;
      final shimmerRect = Rect.fromLTWH(offset, 0, sw, size.height)
          .intersect(Rect.fromLTWH(0, 0, activeW, size.height));

      if (!shimmerRect.isEmpty) {
        final shimmerPaint = Paint()
          ..shader = LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.transparent,
              Colors.white.withValues(alpha: 0.22),
              Colors.white.withValues(alpha: 0.10),
              Colors.transparent,
            ],
            stops: const [0.0, 0.35, 0.65, 1.0],
          ).createShader(shimmerRect)
          ..blendMode = BlendMode.srcOver;

        // Clip to active rounded rect so the shimmer stays inside the active bar
        final rrect = RRect.fromLTRBR(0, 0, activeW, size.height, radius);
        canvas.save();
        canvas.clipRRect(rrect);
        canvas.drawRect(shimmerRect, shimmerPaint);
        canvas.restore();
      }
    }

    // Draw thumb circle
    final thumbRadius = barHeight * 0.5;
    final thumbCenter = Offset(activeW.clamp(thumbRadius, size.width - thumbRadius), centerY);

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    canvas.drawCircle(thumbCenter.translate(0, 1), thumbRadius, shadowPaint);

    final thumbPaint = Paint()
      ..color = thumbColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawCircle(thumbCenter, thumbRadius, thumbPaint);

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..isAntiAlias = true;
    canvas.drawCircle(thumbCenter, thumbRadius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _M3LinearProgressPainter oldDelegate) {
    return (oldDelegate.progress - progress).abs() > 0.01 ||
        oldDelegate.barHeight != barHeight ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.thumbColor != thumbColor ||
        oldDelegate.borderColor != borderColor ||
        (oldDelegate.shimmerPhase - shimmerPhase).abs() > 0.01 ||
        oldDelegate.enableShimmer != enableShimmer;
  }
}

// Keyboard intents
class _IncreaseIntent extends Intent {
  const _IncreaseIntent();
}

class _DecreaseIntent extends Intent {
  const _DecreaseIntent();
}

class _JumpStartIntent extends Intent {
  const _JumpStartIntent();
}

class _JumpEndIntent extends Intent {
  const _JumpEndIntent();
}

