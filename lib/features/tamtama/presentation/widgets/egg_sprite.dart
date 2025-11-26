import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EggSprite extends StatefulWidget {
  static const int _minIndex = 1;
  static const int _maxIndex = 4;
  static const int _filenameOffset = 100;
  static const double _sizeFactor = 0.5;
  static const double _bottomOffsetFactor = 0.1;
  static const int _initialLoops = 5;
  static const int _tapLoops = 2;

  final int eggIndex;

  const EggSprite({required this.eggIndex, super.key});

  @override
  State<EggSprite> createState() => _EggSpriteState();
}

class _EggSpriteState extends State<EggSprite> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int _completedLoops = 0;
  int _targetLoops = EggSprite._initialLoops;

  bool get _isValid =>
      widget.eggIndex >= EggSprite._minIndex && widget.eggIndex <= EggSprite._maxIndex;

  String get _assetPath {
    final resolvedIndex = widget.eggIndex + EggSprite._filenameOffset;
    return 'assets/sprites/eggs/eggs$resolvedIndex.lottie';
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener(_handleStatusChange);
  }

  @override
  void didUpdateWidget(covariant EggSprite oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.eggIndex != widget.eggIndex) {
      _restartAnimation();
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_handleStatusChange);
    _controller.dispose();
    super.dispose();
  }

  void _handleStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _completedLoops += 1;
      if (_completedLoops < _targetLoops) {
        _controller.forward(from: 0);
      }
    }
  }

  void _restartAnimation() {
    _startAnimation(EggSprite._initialLoops);
  }

  void _startAnimation(int loopCount) {
    _targetLoops = loopCount;
    _completedLoops = 0;
    if (_controller.duration != null) {
      _controller.forward(from: 0);
    }
  }

  void _handleTap() {
    _startAnimation(EggSprite._tapLoops);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isValid) {
      if (kDebugMode) {
        debugPrint('EggSprite: invalid eggIndex ${widget.eggIndex}');
      }
      return const SizedBox();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final eggSize = constraints.maxWidth * EggSprite._sizeFactor;
        final bottomPadding = constraints.maxHeight * EggSprite._bottomOffsetFactor;

        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: GestureDetector(
              onTap: _handleTap,
              child: SizedBox(
                width: eggSize,
                height: eggSize,
                child: Lottie.asset(
                  _assetPath,
                  controller: _controller,
                  repeat: false,
                  fit: BoxFit.contain,
                  decoder: _dotLottieDecoder,
                  onLoaded: (composition) {
                    _controller
                      .duration = composition.duration;
                    _startAnimation(EggSprite._initialLoops);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<LottieComposition?> _dotLottieDecoder(List<int> bytes) {
    return LottieComposition.decodeZip(
      bytes,
      filePicker: (files) {
        for (final file in files) {
          if (file.name.startsWith('animations/') && file.name.endsWith('.json')) {
            return file;
          }
        }
        return files.isNotEmpty ? files.first : null;
      },
    );
  }
}

