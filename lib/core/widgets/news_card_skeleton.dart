import 'package:flutter/material.dart';

import '../themes/component_tokens.dart';
import '../themes/design_tokens.dart';
import 'skeleton_box.dart';

class NewsCardSkeleton extends StatelessWidget {
  final int index;
  final int totalItems;

  const NewsCardSkeleton({
    super.key,
    required this.index,
    required this.totalItems,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = NewsCardTokens.of(context);
    final skeletonColor = Theme.of(context).colorScheme.surfaceContainerHighest;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = DesignTokens.spacingL * 2;
    final cardWidth = screenWidth > horizontalPadding
        ? screenWidth - horizontalPadding
        : screenWidth;

    return SizedBox(
      width: cardWidth,
      child: Container(
        margin: EdgeInsets.only(
          left: DesignTokens.spacingL,
          right: index == totalItems - 1
              ? DesignTokens.spacingL
              : DesignTokens.spacingM,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
          boxShadow: [
            BoxShadow(
              color: tokens.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [tokens.gradientStart, tokens.gradientEnd],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(DesignTokens.spacingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SkeletonBox(
                      width: 60,
                      height: 20,
                      color: skeletonColor,
                      borderRadius: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonBox(
                          width: double.infinity,
                          height: 20,
                          color: skeletonColor,
                        ),
                        SizedBox(height: DesignTokens.spacingS),
                        SkeletonBox(
                          width: 100,
                          height: 14,
                          color: skeletonColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
