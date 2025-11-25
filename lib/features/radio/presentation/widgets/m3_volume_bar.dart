import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:tujuhcahaya_wprs/shared/widgets/m3_linear_progress_bar.dart';

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

class _M3VolumeBarState extends State<M3VolumeBar> {
  late double _visualValue; // tweened value for smoothness
  Timer? _animationTimer;

  @override
  void initState() {
    super.initState();
    _visualValue = widget.value.clamp(0.0, 1.0);
  }

  @override
  void didUpdateWidget(covariant M3VolumeBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    _animateTo(widget.value.clamp(0.0, 1.0));
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
                onHorizontalDragUpdate: (d) =>
                    _updateFromDx(d.localPosition.dx, constraints.maxWidth, dir),
                onTapDown: (d) =>
                    _updateFromDx(d.localPosition.dx, constraints.maxWidth, dir),
                child: InkWell(
                  customBorder:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onTap: () {}, // keep ripple
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: 48,
                      minWidth: 48,
                      maxHeight: 48,
                    ),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: radius,
                        child: M3LinearProgressBar(
                          progress: _visualValue.clamp(0.0, 1.0),
                          height: barHeight,
                          trackColor: trackColor,
                          fillColor: theme.colorScheme.primary,
                          thumbColor: theme.colorScheme.primary,
                          thumbBorderColor:
                              theme.colorScheme.onPrimary.withValues(alpha: 0.2),
                          enableShimmer: widget.wavyActive,
                          showThumb: true,
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

