import 'package:flutter/material.dart';

class BackgroundSprite extends StatelessWidget {
  final int index;

  const BackgroundSprite({required this.index, super.key});

  String get _backgroundFilename {
    final paddedIndex = index.toString().padLeft(2, '0');
    return 'assets/sprites/backgrounds/bg_$paddedIndex.png';
  }

  @override
  Widget build(BuildContext context) {
    if (index < 1 || index > 14) {
      return const SizedBox();
    }

    return Image.asset(
      _backgroundFilename,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
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
    );
  }
}
