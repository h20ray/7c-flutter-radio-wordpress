import 'package:flutter/material.dart';

class BackgroundSprite extends StatelessWidget {
  static const int _maxSupportedIndex = 20;
  static const int _filenameOffset = 100;

  final int index;

  const BackgroundSprite({required this.index, super.key});

  String get _backgroundFilename {
    final resolvedIndex = index + _filenameOffset;
    return 'assets/sprites/backgrounds/bg$resolvedIndex.png';
  }

  bool get _isIndexValid => index >= 1 && index <= _maxSupportedIndex;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
      ],
    );
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
