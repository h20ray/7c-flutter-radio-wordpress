import 'package:flutter/material.dart';

import '../themes/design_tokens.dart';
import 'shimmer_skeleton.dart';

class NewsListSkeleton extends StatelessWidget {
  final int itemCount;

  const NewsListSkeleton({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    final skeletonColor = Theme.of(context).colorScheme.surfaceContainerHighest;

    return Padding(
      padding: EdgeInsets.only(top: DesignTokens.spacingXl),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : MediaQuery.sizeOf(context).width;

          return Column(
            children: List.generate(
              itemCount,
              (index) => SizedBox(
                width: availableWidth,
                child: Container(
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
                          padding: EdgeInsets.all(DesignTokens.spacingL),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SkeletonBox(
                                width: 60,
                                height: 20,
                                color: skeletonColor,
                                borderRadius: 8,
                              ),
                              SizedBox(height: DesignTokens.spacingS),
                              SkeletonBox(
                                width: availableWidth,
                                height: 20,
                                color: skeletonColor,
                              ),
                              SizedBox(height: DesignTokens.spacingS),
                              SkeletonBox(
                                width: availableWidth,
                                height: 16,
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
