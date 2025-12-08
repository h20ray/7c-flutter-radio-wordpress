import 'package:flutter/material.dart';
import '../../../../config/share_config.dart';
import '../../../../config/radio_config.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/utils/palette_cache.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/themes/component_tokens.dart';
import '../../../../core/themes/app_color_system.dart';

class RadioShareCard extends StatelessWidget {
  final String? artist;
  final String? title;
  final String? albumArtUrl;
  final PaletteColors? palette;
  final bool isPlaying;
  final bool hasBackground;

  const RadioShareCard({
    super.key,
    this.artist,
    this.title,
    this.albumArtUrl,
    this.palette,
    this.isPlaying = false,
    this.hasBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final displayTitle = title?.trim().isNotEmpty == true
        ? title!.trim()
        : RadioConfig.fallbackTitle;
    final displayArtist = artist?.trim().isNotEmpty == true
        ? artist!.trim()
        : RadioConfig.fallbackArtist;

    final String backgroundImageUrl =
        albumArtUrl ?? RadioConfig.fallbackArtworkPath;
    final bool isNetworkImage = albumArtUrl != null && albumArtUrl!.isNotEmpty;

    return _buildStickerCard(
      context: context,
      theme: theme,
      displayTitle: displayTitle,
      displayArtist: displayArtist,
      backgroundImageUrl: backgroundImageUrl,
      isNetworkImage: isNetworkImage,
    );
  }

  Widget _buildStickerCard({
    required BuildContext context,
    required ThemeData theme,
    required String displayTitle,
    required String displayArtist,
    required String backgroundImageUrl,
    required bool isNetworkImage,
  }) {
    final colors = context.appColors;
    final scheme = colors.colorScheme;
    const cardPadding = DesignTokens.spacingM;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;
        
        final contentWidth = (availableWidth - (cardPadding * 2)).clamp(0.0, double.infinity);
        final contentHeight = (availableHeight - (cardPadding * 2)).clamp(0.0, double.infinity);
        
        final albumArtSize = (contentWidth * 0.75).clamp(
          200.0,
          (contentHeight * 0.6).clamp(200.0, 380.0),
        );

        final textWidth = albumArtSize;
        final remainingHeight = contentHeight - albumArtSize - (DesignTokens.spacingS * 3) - 32;
        final canFitText = remainingHeight >= 40;

        final backgroundColor = hasBackground
            ? (theme.brightness == Brightness.dark
                ? const Color(0xFF121212)
                : const Color(0xFFFAFAFA))
            : Colors.transparent;

        return Container(
          width: double.infinity,
          height: double.infinity,
          color: backgroundColor,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(cardPadding),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
                boxShadow: AppShadowTokens.elevation8(context),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: albumArtSize,
                    height: albumArtSize,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        DesignTokens.cornerRadiusAlbumArt,
                      ),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: isNetworkImage
                            ? AppNetworkImage(
                                imageUrl: backgroundImageUrl,
                                fit: BoxFit.cover,
                                fadeInDuration: Duration.zero,
                              )
                            : Image.asset(
                                backgroundImageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      color: colors
                                          .surfaces
                                          .surfaceContainerHighest,
                                      child: Icon(
                                        Icons.music_note,
                                        size:
                                            DimensionTokens.iconSizeLarge *
                                            2.5,
                                        color: colors.textSecondary,
                                      ),
                                    ),
                              ),
                      ),
                    ),
                  ),
                  if (canFitText) ...[
                    const SizedBox(height: DesignTokens.spacingS),
                    SizedBox(
                      width: textWidth,
                      child: Text(
                        displayTitle.trim(),
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          letterSpacing: -0.3,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacingXs),
                    SizedBox(
                      width: textWidth,
                      child: Text(
                        displayArtist.trim(),
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          letterSpacing: -0.3,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacingS),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacingS,
                        vertical: DesignTokens.spacingXs,
                      ),
                      decoration: BoxDecoration(
                        color: colors.textPrimary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(
                          DesignTokens.cornerRadiusPill,
                        ),
                        border: Border.all(
                          color: colors.textPrimary.withValues(alpha: 0.2),
                          width: DimensionTokens.borderWidthThin,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (ShareConfig.useLogoAsset)
                            Image.asset(
                              ShareConfig.logoAssetPath,
                              width: 12,
                              height: 12,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                    Icons.radio,
                                    size: 12,
                                    color: colors.textPrimary,
                                  ),
                            )
                          else
                            Icon(
                              Icons.radio,
                              size: 12,
                              color: colors.textPrimary,
                            ),
                          const SizedBox(width: DesignTokens.spacingXs),
                          Text(
                            ShareConfig.appName,
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontSize: DesignTokens.fontSizeLabelSmall,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
