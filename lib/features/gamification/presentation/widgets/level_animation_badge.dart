import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../config/game_radio_time_config.dart';

class LevelAnimationBadge extends StatefulWidget {
  final double size;
  final String imageAssetPath;
  final String? animationAssetPath;
  final bool enableAnimation;
  final bool isLocked;
  final VoidCallback? onTap;
  final int? backgroundColor;
  final int? initialLoopCount;

  const LevelAnimationBadge({
    super.key,
    required this.size,
    required this.imageAssetPath,
    this.animationAssetPath,
    this.enableAnimation = true,
    this.isLocked = false,
    this.onTap,
    this.backgroundColor,
    this.initialLoopCount,
  });

  @override
  State<LevelAnimationBadge> createState() => _LevelAnimationBadgeState();
}

class _LevelAnimationBadgeState extends State<LevelAnimationBadge>
    with SingleTickerProviderStateMixin {
  static const Duration _tapDebounce = Duration(milliseconds: 250);

  late final AnimationController _controller;
  final Random _random = Random();

  int _loopsRemaining = 0;
  bool _animationReady = false;
  DateTime? _lastTap;

  bool get _hasAnimation =>
      widget.animationAssetPath != null &&
      widget.animationAssetPath!.isNotEmpty &&
      !widget.isLocked &&
      widget.enableAnimation;

  Color? _resolveBackgroundColor() {
    final colorValue = widget.backgroundColor;
    if (colorValue == null) {
      return null;
    }
    final baseColor = Color(colorValue);
    final hsl = HSLColor.fromColor(baseColor);
    final darker =
        hsl.withLightness((hsl.lightness * 0.5).clamp(0.0, 1.0)).toColor();
    final target = widget.isLocked ? baseColor.withValues(alpha: 0.6) : darker;
    return target;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener(_handleStatusChange);
  }

  @override
  void didUpdateWidget(LevelAnimationBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationAssetPath != widget.animationAssetPath) {
      _resetAnimation();
    }
    if (oldWidget.enableAnimation != widget.enableAnimation && widget.enableAnimation) {
      _queueInitialLoops();
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_handleStatusChange);
    _controller.dispose();
    super.dispose();
  }

  void _resetAnimation() {
    _controller.stop();
    _controller.reset();
    _animationReady = false;
    _loopsRemaining = 0;
  }

  void _handleStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _loopsRemaining -= 1;
      if (_loopsRemaining > 0) {
        _controller.forward(from: 0);
      }
    }
  }

  int get _initialLoopTarget {
    final loops =
        widget.initialLoopCount ?? GameRadioTimeConfig.levelAnimationInitialLoops;
    return loops < 0 ? 0 : loops;
  }

  int get _tapLoopMin {
    final minLoops = GameRadioTimeConfig.levelAnimationTapLoopMin;
    return minLoops < 1 ? 1 : minLoops;
  }

  int get _tapLoopMax {
    final maxLoops = GameRadioTimeConfig.levelAnimationTapLoopMax;
    final minLoops = _tapLoopMin;
    return maxLoops < minLoops ? minLoops : maxLoops;
  }

  void _queueInitialLoops() {
    if (_hasAnimation && _animationReady) {
      _startLoops(_initialLoopTarget, restart: true);
    }
  }

  void _startLoops(int loops, {bool restart = false}) {
    if (!_hasAnimation || !_animationReady || loops <= 0) {
      return;
    }
    
    final isCurrentlyAnimating = _controller.isAnimating;
    
    if (isCurrentlyAnimating && !restart) {
      _loopsRemaining += loops;
    } else {
      _loopsRemaining = loops;
      _controller.forward(from: 0);
    }
  }

  void _handleTap() {
    if (_hasAnimation) {
      final now = DateTime.now();
      if (_lastTap == null || now.difference(_lastTap!) >= _tapDebounce) {
        final minLoops = _tapLoopMin;
        final maxLoops = _tapLoopMax;
        final loops = minLoops == maxLoops
            ? minLoops
            : _random.nextInt(maxLoops - minLoops + 1) + minLoops;
        _startLoops(loops, restart: false);
      }
      _lastTap = now;
    }
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _handleTap,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 1.2,
            ),
            color: _resolveBackgroundColor(),
          ),
          clipBehavior: Clip.antiAlias,
          child: ClipRRect(
            borderRadius: borderRadius,
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (!_hasAnimation) {
      return Image.asset(
        widget.imageAssetPath,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.cover,
        color: widget.isLocked ? Colors.black.withValues(alpha: 0.2) : null,
        colorBlendMode: widget.isLocked ? BlendMode.srcATop : null,
      );
    }

    return Lottie.asset(
      widget.animationAssetPath!,
      controller: _controller,
      repeat: false,
      fit: BoxFit.cover,
      decoder: _dotLottieDecoder,
      onLoaded: (composition) {
        if (!mounted) {
          return;
        }
        _controller.duration = composition.duration;
        _animationReady = true;
        _queueInitialLoops();
      },
      errorBuilder: (context, error, stackTrace) {
        debugPrint('LevelAnimationBadge: Failed to load animation: $error');
        return Image.asset(
          widget.imageAssetPath,
          width: widget.size,
          height: widget.size,
          fit: BoxFit.cover,
          color: widget.isLocked ? Colors.black.withValues(alpha: 0.2) : null,
          colorBlendMode: widget.isLocked ? BlendMode.srcATop : null,
        );
      },
    );
  }

  Future<LottieComposition?> _dotLottieDecoder(List<int> bytes) {
    return LottieComposition.decodeZip(
      bytes,
      filePicker: (files) {
        for (final file in files) {
          if (file.name.startsWith('animations/') &&
              file.name.endsWith('.json')) {
            return file;
          }
        }
        return files.isNotEmpty ? files.first : null;
      },
    );
  }
}

