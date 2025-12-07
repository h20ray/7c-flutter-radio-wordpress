import '../../../../../core/widgets/app_network_image.dart';
import '../../../../../core/cache/news_image_cache_manager.dart';
import 'package:flutter/material.dart';

import '../../../../../core/themes/app_color_system.dart';
import '../../../../../core/themes/design_tokens.dart';

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
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(DesignTokens.cornerRadiusCard),
            topRight: Radius.circular(DesignTokens.cornerRadiusCard),
          ),
          child: RepaintBoundary(
            child: AppNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              memCacheWidth: 800,
              memCacheHeight: 450,
              fadeInDuration: Duration.zero,
              cacheManager: NewsImageCacheManager(),
              placeholder: (context, url) => Container(
                color: skeletonColor,
              ),
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
      ),
    );
  }
}

