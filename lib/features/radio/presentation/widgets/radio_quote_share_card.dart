import 'package:flutter/material.dart';
import '../../../../config/share_config.dart';
import '../../../../config/radio_config.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/themes/share_card_tokens.dart';
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
    final tokens = ShareCardTokens.of(context);

    final String backgroundImageUrl = albumArtUrl ?? RadioConfig.fallbackArtworkPath;
    final bool isNetworkImage = albumArtUrl != null && albumArtUrl!.isNotEmpty;

    return Container(
      width: width,
      height: height,
      color: tokens.background,
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
                color: tokens.background,
              ),
            ),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: tokens.overlayGradient,
                stops: const [0.0, 0.3, 0.7, 1.0],
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
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.format_quote,
                            color: tokens.textPrimary.withValues(alpha: 0.9),
                            size: DimensionTokens.avatarSizeMedium,
                          ),
                          const SizedBox(height: DesignTokens.spacingXl),
                          Text(
                            quote,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: tokens.textPrimary,
                              fontSize: DesignTokens.fontSizeHeadlineLarge + DesignTokens.spacingS,
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

                const SizedBox(height: DesignTokens.spacingXl),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    ShareConfig.appNameFull,
                    style: TextStyle(
                      color: tokens.textSecondary,
                      fontSize: DesignTokens.fontSizeBodyMedium,
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

