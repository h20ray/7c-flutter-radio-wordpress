import 'dart:math' as math;

import 'package:flutter/material.dart';

class BackgroundSprite extends StatelessWidget {
  static const int _maxSupportedIndex = 20;
  static const int _filenameOffset = 100;
  static const double _spriteAspectRatio = 1;

  final int index;

  const BackgroundSprite({required this.index, super.key});

  String get _backgroundFilename {
    final resolvedIndex = index + _filenameOffset;
    return 'assets/sprites/backgrounds/bg$resolvedIndex.png';
  }

  bool get _isIndexValid => index >= 1 && index <= _maxSupportedIndex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final spriteHeight = _resolveSpriteHeight(
          constraints.maxWidth,
          constraints.maxHeight,
        );
        final woodTrimTop = _resolveWoodTrimTop(
          constraints.maxHeight,
          spriteHeight,
        );

        return SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const _TimeOfDayBackground(),
              if (_isIndexValid)
                Image.asset(
                  _backgroundFilename,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[600],
                          size: 40,
                        ),
                      ),
                    );
                  },
                ),
              _WoodTrim(top: woodTrimTop),
            ],
          ),
        );
      },
    );
  }

  double _resolveSpriteHeight(double width, double height) {
    if (!width.isFinite || !height.isFinite) {
      return height;
    }

    final heightFromWidth = width / _spriteAspectRatio;
    return math.min(height, heightFromWidth);
  }

  double _resolveWoodTrimTop(double maxHeight, double spriteHeight) {
    final rawTop = maxHeight - spriteHeight;
    final maxTop = math.max(0.0, maxHeight - _WoodTrim.trimHeight);
    return rawTop.clamp(0.0, maxTop);
  }
}

class _TimeOfDayBackground extends StatelessWidget {
  const _TimeOfDayBackground();

  String _resolveAsset() {
    final now = DateTime.now();
    final minutesSinceMidnight = now.hour * 60 + now.minute;

    final dayStart = 6 * 60;
    final afternoonStart = 15 * 60 + 30;
    final nightStart = 18 * 60;

    if (minutesSinceMidnight >= dayStart && minutesSinceMidnight < afternoonStart) {
      return 'assets/sprites/backgrounds/time_day.png';
    } else if (minutesSinceMidnight >= afternoonStart && minutesSinceMidnight < nightStart) {
      return 'assets/sprites/backgrounds/time_afternoon.png';
    } else if (minutesSinceMidnight >= nightStart) {
      return 'assets/sprites/backgrounds/time_night.png';
    } else if (minutesSinceMidnight < dayStart) {
      return 'assets/sprites/backgrounds/time_midnight.png';
    } else {
      return 'assets/sprites/backgrounds/time_midnight.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _resolveAsset(),
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.contain,
      alignment: Alignment.topCenter,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[200],
          child: Center(
            child: Icon(
              Icons.wb_sunny,
              color: Colors.grey[500],
              size: 32,
            ),
          ),
        );
      },
    );
  }
}

class _WoodTrim extends StatelessWidget {
  static const double trimHeight = 5;

  final double top;

  const _WoodTrim({required this.top});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: 0,
      right: 0,
      child: Container(
        height: trimHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF2D160C),
              Color(0xFF603317),
              Color(0xFF9B6B3B),
              Color(0xFF603317),
              Color(0xFF2D160C),
            ],
            stops: [0, 0.2, 0.5, 0.8, 1],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x44000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}
