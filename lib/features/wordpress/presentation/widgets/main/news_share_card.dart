import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../../config/share_config.dart';
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

    return Container(
      width: width,
      height: height,
      color: Colors.black,
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
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.1),
                  Colors.black.withValues(alpha: 0.8),
                  Colors.black,
                ],
                stops: const [0.0, 0.4, 0.8, 1.0],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: ShareConfig.useLogoAsset
                            ? Image.asset(
                                ShareConfig.logoAssetPath,
                                width: 20,
                                height: 20,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                  Icons.radio,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              )
                            : const Icon(
                                Icons.radio,
                                color: Colors.black,
                                size: 20,
                              ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        ShareConfig.appName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
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
                      
                      const SizedBox(height: 16),

                      Text(
                        post.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Read more on',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ShareConfig.appNameFull,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
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
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
                
                if (post.link.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          LucideIcons.link,
                          size: 20,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ),
                
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

