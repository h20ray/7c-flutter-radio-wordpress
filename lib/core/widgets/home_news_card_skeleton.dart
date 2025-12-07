import 'package:flutter/material.dart';

import '../themes/app_color_system.dart';
import '../themes/design_tokens.dart';
import 'shimmer_skeleton.dart';

class HomeNewsCardSkeleton extends StatelessWidget {
  final int itemCount;

  const HomeNewsCardSkeleton({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final skeletonColor = Theme.of(context).colorScheme.surfaceContainerHighest;

    return Column(
      children: List.generate(
        itemCount,
        (index) => Container(
          margin: const EdgeInsets.fromLTRB(
            DesignTokens.spacingL,
            DesignTokens.spacingS,
            DesignTokens.spacingL,
            0,
          ),
          padding: const EdgeInsets.all(DesignTokens.spacingM),
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(
                width: 72,
                height: 72,
                color: skeletonColor,
                borderRadius: 16,
              ),
              const SizedBox(width: DesignTokens.spacingM),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SkeletonBox(
                          width: constraints.maxWidth,
                          height: 16,
                          color: skeletonColor,
                        ),
                        const SizedBox(height: DesignTokens.spacingXs),
                        SkeletonBox(
                          width: constraints.maxWidth * 0.85,
                          height: 16,
                          color: skeletonColor,
                        ),
                        const SizedBox(height: DesignTokens.spacingS),
                        Row(
                          children: [
                            SkeletonBox(
                              width: 60,
                              height: 20,
                              color: skeletonColor,
                              borderRadius: 12,
                            ),
                            const SizedBox(width: DesignTokens.spacingXs),
                            SkeletonBox(
                              width: 50,
                              height: 20,
                              color: skeletonColor,
                              borderRadius: 12,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
