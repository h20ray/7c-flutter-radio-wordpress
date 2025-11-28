import 'package:flutter/material.dart';

class SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final double borderRadius;

  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    required this.color,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

