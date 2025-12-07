import 'package:flutter/material.dart';
import '../../../../config/share_config.dart';
import '../../../../config/radio_config.dart';
import '../../../../core/widgets/app_network_image.dart';

class RadioQuoteShareCard extends StatelessWidget {
  final String quote;
  final String? albumArtUrl;

  const RadioQuoteShareCard({
    super.key,
    required this.quote,
    this.albumArtUrl,
  });

  @override
  Widget build(BuildContext context) {
    const double width = 360;
    const double height = 640;

    final String backgroundImageUrl = albumArtUrl ?? RadioConfig.fallbackArtworkPath;
    final bool isNetworkImage = albumArtUrl != null && albumArtUrl!.isNotEmpty;

    return Container(
      width: width,
      height: height,
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (isNetworkImage)
            AppNetworkImage(
              imageUrl: backgroundImageUrl,
              fit: BoxFit.cover,
              width: width,
              height: height,
              fadeInDuration: Duration.zero,
            )
          else
            Image.asset(
              backgroundImageUrl,
              fit: BoxFit.cover,
              width: width,
              height: height,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.black,
              ),
            ),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  Colors.black.withValues(alpha: 0.2),
                  Colors.black.withValues(alpha: 0.6),
                  Colors.black.withValues(alpha: 0.85),
                ],
                stops: const [0.0, 0.3, 0.7, 1.0],
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
                        style: const TextStyle(
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
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.format_quote,
                            color: Colors.white.withValues(alpha: 0.9),
                            size: 48,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            quote,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              height: 1.4,
                              fontFamily: 'Inter',
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    ShareConfig.appNameFull,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

