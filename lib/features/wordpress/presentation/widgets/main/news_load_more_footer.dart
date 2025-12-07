import 'package:flutter/material.dart';

import '../../../../../core/themes/design_tokens.dart';
import '../../../../../core/widgets/shimmer_skeleton.dart';

class NewsLoadMoreFooter extends StatelessWidget {
  const NewsLoadMoreFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final skeletonColor = Theme.of(context).colorScheme.surfaceContainerHighest;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        return Column(
          children: List.generate(
            1,
            (index) => Container(
              margin: EdgeInsets.only(bottom: DesignTokens.spacingL),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(
                  DesignTokens.cornerRadiusCard,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  DesignTokens.cornerRadiusCard,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: SkeletonBox(
                        width: availableWidth,
                        height: availableWidth / (16 / 9),
                        color: skeletonColor,
                        borderRadius: 0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(DesignTokens.spacingM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SkeletonBox(
                                width: 60,
                                height: 20,
                                color: skeletonColor,
                                borderRadius: 12,
                              ),
                              const SizedBox(width: DesignTokens.spacingS),
                              SkeletonBox(
                                width: 80,
                                height: 20,
                                color: skeletonColor,
                                borderRadius: 12,
                              ),
                            ],
                          ),
                          const SizedBox(height: DesignTokens.spacingS),
                          SkeletonBox(
                            width: availableWidth - (DesignTokens.spacingM * 2),
                            height: 20,
                            color: skeletonColor,
                          ),
                          const SizedBox(height: DesignTokens.spacingS),
                          SkeletonBox(
                            width: availableWidth - (DesignTokens.spacingM * 2),
                            height: 16,
                            color: skeletonColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

