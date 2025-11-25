import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../shared/widgets/m3_linear_progress_bar.dart';

class AnimatedGameProgress extends StatefulWidget {
  const AnimatedGameProgress({
    super.key,
    required this.progress,
    this.height,
    this.trackColor,
    this.fillColor,
    this.onProgressChanged,
    this.animationDuration = const Duration(milliseconds: 900),
    this.animationCurve = Curves.easeOutCubic,
    this.animateFromZeroOnMount = true,
    this.enableShimmer = true,
  });

  final double progress;
  final double? height;
  final Color? trackColor;
  final Color? fillColor;
  final ValueChanged<double>? onProgressChanged;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool animateFromZeroOnMount;
  final bool enableShimmer;

  @override
  State<AnimatedGameProgress> createState() => _AnimatedGameProgressState();
}

class _AnimatedGameProgressState extends State<AnimatedGameProgress>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _visualProgress = 0.0;
  double _displayTarget = 0.0;
  double _displayStart = 0.0;
  bool _initialized = false;

  bool get _animationsAllowed =>
      MediaQuery.maybeOf(context)?.disableAnimations != true &&
      TickerMode.of(context);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this)..addListener(_handleTick);

    _displayTarget = widget.progress.clamp(0.0, 1.0);
    _visualProgress = widget.animateFromZeroOnMount ? 0.0 : _displayTarget;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _startAnimation(_displayTarget,
            fromZero: widget.animateFromZeroOnMount);
      });
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedGameProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextTarget = widget.progress.clamp(0.0, 1.0);
    final progressChanged = (nextTarget - _displayTarget).abs() > 0.001;
    final animationConfigChanged =
        widget.animationDuration != oldWidget.animationDuration ||
            widget.animationCurve != oldWidget.animationCurve;

    _displayTarget = nextTarget;
    if (progressChanged || animationConfigChanged) {
      _startAnimation(_displayTarget);
    }
  }

  void _handleTick() {
    if (!mounted) {
      return;
    }
    final eased = widget.animationCurve.transform(_controller.value);
    final value = lerpDouble(_displayStart, _displayTarget, eased) ?? 0.0;
    setState(() {
      _visualProgress = value.clamp(0.0, 1.0);
    });
    widget.onProgressChanged?.call(_visualProgress);
  }

  void _startAnimation(double target, {bool fromZero = false}) {
    if (!_animationsAllowed) {
      setState(() {
        _visualProgress = target;
      });
      widget.onProgressChanged?.call(_visualProgress);
      return;
    }

    final nextStart = fromZero ? 0.0 : _visualProgress;
    final delta = (target - nextStart).abs();
    if (delta < 0.001) {
      setState(() {
        _visualProgress = target;
      });
      return;
    }

    final scaledDuration =
        _scaledDuration(widget.animationDuration, delta: delta);
    if (scaledDuration == Duration.zero) {
      setState(() {
        _visualProgress = target;
      });
      widget.onProgressChanged?.call(_visualProgress);
      return;
    }
    _displayStart = nextStart;
    _displayTarget = target;

    _controller
      ..duration = scaledDuration
      ..reset()
      ..forward();
  }

  Duration _scaledDuration(Duration base, {required double delta}) {
    final baseMs = base.inMilliseconds;
    if (baseMs <= 0) {
      return Duration.zero;
    }
    final scaled =
        (baseMs * delta.clamp(0.25, 1.0)).clamp(140, baseMs).round();
    return Duration(milliseconds: scaled);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleTick)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return M3LinearProgressBar(
      progress: _visualProgress.clamp(0.0, 1.0),
      height: widget.height,
      trackColor: widget.trackColor,
      fillColor: widget.fillColor,
      enableShimmer: widget.enableShimmer,
      animateProgress: false,
      loopProgressAnimation: false,
    );
  }
}

