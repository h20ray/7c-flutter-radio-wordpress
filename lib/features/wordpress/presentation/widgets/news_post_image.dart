import '../../../../core/widgets/app_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/widgets/skeleton_box.dart';

class NewsPostImage extends StatelessWidget {
  final String imageUrl;
  final String? semanticLabel;

  const NewsPostImage({
    super.key,
    required this.imageUrl,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final skeletonColor = Theme.of(context).colorScheme.surfaceContainerHighest;

    return Semantics(
      label: semanticLabel,
      image: true,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(DesignTokens.cornerRadiusCard),
            topRight: Radius.circular(DesignTokens.cornerRadiusCard),
          ),
          child: AppNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            memCacheWidth: 800,
            memCacheHeight: 450,
            placeholder: (context, url) => SkeletonBox(
              width: double.infinity,
              height: double.infinity,
              color: skeletonColor,
              borderRadius: 0,
            ),
            imageBuilder: (context, provider) {
              return AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: provider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
            errorWidget: (context, url, error) => Container(
              color: colors.borderSubtle,
              child: Icon(
                Icons.image_not_supported,
                color: colors.textSecondary,
                size: 48,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


