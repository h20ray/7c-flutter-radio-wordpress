import 'package:flutter/material.dart';
import '../../../../../core/themes/design_tokens.dart';

class LevelDetailsLoadingState extends StatelessWidget {
  const LevelDetailsLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    final skeletonColor = Theme.of(context).colorScheme.surfaceContainerHighest;

    return Padding(
      padding: EdgeInsets.all(DesignTokens.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkeletonBox(
            width: 120,
            height: 120,
            color: skeletonColor,
            borderRadius: DesignTokens.cornerRadiusCard,
          ),
          SizedBox(height: DesignTokens.spacingL),
          _SkeletonBox(
            width: 200,
            height: 24,
            color: skeletonColor,
          ),
          SizedBox(height: DesignTokens.spacingS),
          _SkeletonBox(
            width: double.infinity,
            height: 16,
            color: skeletonColor,
          ),
          SizedBox(height: DesignTokens.spacingM),
          _SkeletonBox(
            width: double.infinity,
            height: 8,
            color: skeletonColor,
            borderRadius: DesignTokens.cornerRadiusProgress,
          ),
          SizedBox(height: DesignTokens.spacingXl * 2),
          _SkeletonBox(
            width: 150,
            height: 20,
            color: skeletonColor,
          ),
          SizedBox(height: DesignTokens.spacingL),
          ...List.generate(
            3,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: DesignTokens.spacingM),
              child: _SkeletonBox(
                width: double.infinity,
                height: 80,
                color: skeletonColor,
                borderRadius: DesignTokens.cornerRadiusCard,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final double borderRadius;

  const _SkeletonBox({
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

