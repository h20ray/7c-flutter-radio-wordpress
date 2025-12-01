import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../config/share_config.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../domain/entities/post_entity.dart';

class NewsShareCard extends StatelessWidget {
  final PostEntity post;

  const NewsShareCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    // Fixed size for 9:16 aspect ratio (e.g., 1080x1920 scaled down)
    // We use a fixed width for consistency in generation
    const double width = 360;
    const double height = 640;

    return Container(
      width: width,
      height: height,
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          if (post.featuredImageUrl != null)
            AppNetworkImage(
              imageUrl: post.featuredImageUrl!,
              fit: BoxFit.cover,
              width: width,
              height: height,
              fadeInDuration: Duration.zero,
            ),

          // Dark Overlay Gradient
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

          // Content
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Logo / Branding
                Row(
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
                
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Spacer(),
                      
                      // Category
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

                      // Title
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

                // Footer / CTA
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
                    // Date
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
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
