import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../../config/share_config.dart';
import '../../../../../core/themes/design_tokens.dart';
import '../../../../../core/themes/share_card_tokens.dart';
import '../../../../../core/widgets/app_network_image.dart';
import '../../../../../core/cache/news_image_cache_manager.dart';
import '../../../domain/entities/post_entity.dart';

class NewsShareCard extends StatelessWidget {
  final PostEntity post;

  const NewsShareCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    const double width = 360;
    const double height = 640;
    final tokens = ShareCardTokens.of(context);

    return Container(
      width: width,
      height: height,
      color: tokens.background,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (post.featuredImageUrl != null)
            AppNetworkImage(
              imageUrl: post.featuredImageUrl!,
              fit: BoxFit.cover,
              width: width,
              height: height,
              fadeInDuration: Duration.zero,
              cacheManager: NewsImageCacheManager(),
            ),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  tokens.background.withValues(alpha: 0.3),
                  tokens.background.withValues(alpha: 0.1),
                  tokens.background.withValues(alpha: 0.8),
                  tokens.background,
                ],
                stops: const [0.0, 0.4, 0.8, 1.0],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingXxl + DesignTokens.spacingS),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(DesignTokens.spacingS),
                        decoration: BoxDecoration(
                          color: tokens.iconBackground,
                          shape: BoxShape.circle,
                        ),
                        child: ShareConfig.useLogoAsset
                            ? Image.asset(
                                ShareConfig.logoAssetPath,
                                width: DimensionTokens.iconSizeMedium,
                                height: DimensionTokens.iconSizeMedium,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                  Icons.radio,
                                  color: tokens.iconForeground,
                                  size: DimensionTokens.iconSizeMedium,
                                ),
                              )
                            : Icon(
                                Icons.radio,
                                color: tokens.iconForeground,
                                size: DimensionTokens.iconSizeMedium,
                              ),
                      ),
                      const SizedBox(width: DesignTokens.spacingM),
                      Text(
                        ShareConfig.appName,
                        style: TextStyle(
                          color: tokens.textPrimary,
                          fontSize: DesignTokens.fontSizeBodyLarge,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Spacer(),
                      
                      if (post.categoryName != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            post.categoryName!.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      
                      const SizedBox(height: DesignTokens.spacingL),

                      Text(
                        post.title,
                        style: TextStyle(
                          color: tokens.textPrimary,
                          fontSize: DesignTokens.fontSizeHeadlineMedium,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: DesignTokens.spacingXl),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Read more on',
                            style: TextStyle(
                              color: tokens.textSecondary,
                              fontSize: DesignTokens.fontSizeLabelMedium,
                            ),
                          ),
                          const SizedBox(height: DesignTokens.spacingXs),
                          Text(
                            ShareConfig.appNameFull,
                            style: TextStyle(
                              color: tokens.textPrimary,
                              fontSize: DesignTokens.fontSizeBodyMedium,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (post.date != null)
                      Text(
                        DateFormat('dd MMM yyyy').format(post.date!),
                        style: TextStyle(
                          color: tokens.textSecondary,
                          fontSize: DesignTokens.fontSizeLabelMedium,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
                
                if (post.link.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: DesignTokens.spacingM),
                    child: Container(
                      width: DimensionTokens.avatarSizeMedium,
                      height: DimensionTokens.avatarSizeMedium,
                      decoration: BoxDecoration(
                        color: tokens.textPrimary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: tokens.textPrimary.withValues(alpha: 0.3),
                          width: DimensionTokens.borderWidthMedium,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          LucideIcons.link,
                          size: DimensionTokens.iconSizeMedium,
                          color: tokens.textPrimary.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ),
                
                const SizedBox(height: DesignTokens.spacingL),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

