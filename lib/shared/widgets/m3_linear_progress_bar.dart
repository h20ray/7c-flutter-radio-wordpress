import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/themes/linear_indicator_theme.dart';
import 'm3_linear_progress_painter.dart';

class M3LinearProgressBar extends StatefulWidget {
  const M3LinearProgressBar({
    super.key,
    required this.progress,
    this.height,
    this.trackColor,
    this.fillColor,
    this.thumbColor,
    this.thumbBorderColor,
    this.enableShimmer,
    this.showThumb = false,
    this.animateProgress = true,
    this.animationDuration,
    this.animationCurve,
    this.animateFromZeroOnMount = false,
    this.loopProgressAnimation = false,
    this.loopPause = const Duration(milliseconds: 1400),
  });

  final double progress;
  final double? height;
  final Color? trackColor;
  final Color? fillColor;
  final Color? thumbColor;
  final Color? thumbBorderColor;
  final bool? enableShimmer;
  final bool showThumb;
  final bool animateProgress;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final bool animateFromZeroOnMount;
  final bool loopProgressAnimation;
  final Duration loopPause;

  @override
  State<M3LinearProgressBar> createState() => _M3LinearProgressBarState();
}

class _M3LinearProgressBarState extends State<M3LinearProgressBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;
  Timer? _progressTimer;
  Timer? _loopTimer;
  late double _visualProgress;
  late double _targetProgress;

  @override
  void initState() {
    super.initState();
    _targetProgress = widget.progress.clamp(0.0, 1.0);
    _visualProgress =
        widget.animateFromZeroOnMount ? 0.0 : _targetProgress;
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    if (widget.animateFromZeroOnMount ||
        (widget.loopProgressAnimation && widget.animateProgress)) {
      WidgetsBinding.instance.addPostFrameCallback((duration) {
        if (!mounted) return;
        _animateTo(_targetProgress);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncShimmerState();
  }

  @override
  void didUpdateWidget(covariant M3LinearProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextTarget = widget.progress.clamp(0.0, 1.0);
    final progressChanged = (nextTarget - _targetProgress).abs() > 0.001;
    final loopChanged =
        widget.loopProgressAnimation != oldWidget.loopProgressAnimation;
    final animateFlagChanged =
        widget.animateProgress != oldWidget.animateProgress;

    _targetProgress = nextTarget;

    if (progressChanged || loopChanged || animateFlagChanged) {
      if (!widget.animateProgress || !_animationsAllowed) {
        _progressTimer?.cancel();
        _loopTimer?.cancel();
        setState(() {
          _visualProgress = _targetProgress;
        });
      } else {
        if (loopChanged && !widget.loopProgressAnimation) {
          _loopTimer?.cancel();
        }
        _animateTo(_targetProgress);
      }
    }

    if (widget.enableShimmer != oldWidget.enableShimmer ||
        widget.animateProgress != oldWidget.animateProgress ||
        widget.showThumb != oldWidget.showThumb ||
        !_shimmerController.isAnimating && _effectiveShimmer) {
      _syncShimmerState();
    }
  }

  bool get _animationsAllowed =>
      MediaQuery.maybeOf(context)?.disableAnimations != true &&
      TickerMode.of(context);

  bool get _effectiveShimmer {
    final theme = Theme.of(context).linearIndicatorTheme;
    return widget.enableShimmer ?? theme.enableShimmer;
  }

  void _syncShimmerState() {
    final shouldAnimate = _effectiveShimmer && _animationsAllowed;
    if (shouldAnimate && !_shimmerController.isAnimating) {
      _shimmerController.repeat();
    } else if (!shouldAnimate && _shimmerController.isAnimating) {
      _shimmerController.stop();
    }
  }

  void _animateTo(double target) {
    _progressTimer?.cancel();
    _loopTimer?.cancel();

    final animate = widget.animateProgress && _animationsAllowed;
    if (!animate) {
      setState(() {
        _visualProgress = target;
      });
      return;
    }

    final theme = Theme.of(context).linearIndicatorTheme;
    final duration = widget.animationDuration ?? theme.animationDuration;
    final curve = widget.animationCurve ?? theme.animationCurve;
    final start = _visualProgress;

    if ((start - target).abs() < 0.001 || duration.inMilliseconds <= 0) {
      setState(() {
        _visualProgress = target;
      });
      if (widget.loopProgressAnimation &&
          _animationsAllowed &&
          target > 0.0) {
        _scheduleLoop();
      }
      return;
    }

    final startTime = DateTime.now();
    _progressTimer =
        Timer.periodic(const Duration(milliseconds: 16), (timer) {
      final elapsed = DateTime.now().difference(startTime);
      final normalized =
          (elapsed.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
      final eased = curve.transform(normalized);
      final value = start + (target - start) * eased;

      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _visualProgress = value;
      });

      if (normalized >= 1.0) {
        timer.cancel();
        if (!mounted) return;
        setState(() {
          _visualProgress = target;
        });
        if (widget.loopProgressAnimation &&
            _animationsAllowed &&
            target > 0.0) {
          _scheduleLoop();
        }
      }
    });
  }

  void _scheduleLoop() {
    _loopTimer?.cancel();
    if (!widget.loopProgressAnimation || !_animationsAllowed) {
      return;
    }
    _loopTimer = Timer(widget.loopPause, () {
      if (!mounted || !widget.loopProgressAnimation) return;
      setState(() {
        _visualProgress = 0.0;
      });
      _animateTo(_targetProgress);
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _loopTimer?.cancel();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).linearIndicatorTheme;
    final barHeight = (widget.height ?? theme.barHeight).clamp(2.0, 20.0);
    final trackColor = widget.trackColor ?? theme.trackColor;
    final activeColor = widget.fillColor ?? theme.activeColor;
    final thumbColor = widget.thumbColor ?? theme.thumbColor;
    final thumbBorderColor = widget.thumbBorderColor ?? theme.thumbBorderColor;
    final shimmerEnabled =
        _effectiveShimmer && _shimmerController.isAnimating;

    return SizedBox(
      height: barHeight,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _shimmerController,
        builder: (context, _) {
          return CustomPaint(
            painter: M3LinearProgressPainter(
              progress: _visualProgress.clamp(0.0, 1.0),
              barHeight: barHeight,
              activeColor: activeColor,
              trackColor: trackColor,
              thumbColor: thumbColor,
              borderColor: thumbBorderColor,
              shimmerPhase: _shimmerController.value,
              enableShimmer: shimmerEnabled,
              showThumb: widget.showThumb,
            ),
          );
        },
      ),
    );
  }
}

