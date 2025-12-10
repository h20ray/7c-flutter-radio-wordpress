import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../config/radio_config.dart';
import '../../../../config/share_config.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/utils/palette_cache.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';

class LyricShareCard extends StatelessWidget {
  final List<String> lines;
  final String artist;
  final String title;
  final String? albumArtUrl;
  final PaletteColors? palette;
  final bool isSticker;
  final bool hasBackground;
  final bool showPreviewOnly;

  const LyricShareCard({
    super.key,
    required this.lines,
    required this.artist,
    required this.title,
    this.albumArtUrl,
    this.palette,
    this.isSticker = false,
    this.hasBackground = false,
    this.showPreviewOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    // Sticker capture centers the card on transparent background (Instagram adds gradient)
    if (isSticker) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: Center(
          child: _buildStickerCard(context, theme, colors),
        ),
      );
    }

    if (hasBackground) {
      return _buildWithBackground(context, theme, colors);
    }

    // Dialog preview uses the sticker-style card on plain background
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: theme.scaffoldBackgroundColor,
      child: Center(
        child: showPreviewOnly
            ? _buildPreviewOnlyCard(context, theme, colors)
            : _buildStickerCard(context, theme, colors),
      ),
    );
  }

  Widget _buildWithBackground(
    BuildContext context,
    ThemeData theme,
    dynamic colors,
  ) {
    final topColor =
        palette?.vibrant ?? palette?.dominant ?? const Color(0xFF3A3A3C);
    final bottomColor =
        palette?.darkVibrant ?? palette?.muted ?? const Color(0xFF1C1C1E);

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [topColor, bottomColor],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (albumArtUrl != null && albumArtUrl!.isNotEmpty)
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Transform.scale(
                scale: 1.2,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: buildAppNetworkImageProvider(albumArtUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.15),
                  Colors.black.withValues(alpha: 0.45),
                ],
              ),
            ),
          ),
          Center(child: _buildCard(context, theme, colors, forSticker: false)),
        ],
      ),
    );
  }

  Widget _buildPreviewOnlyCard(
    BuildContext context,
    ThemeData theme,
    dynamic colors,
  ) {
    const textColor = Colors.white;
    final totalText = lines.join('\n');
    final baseLyricFontSize = _calculateLyricFontSize(totalText.length, true);
    const cardColor = Color(0xFF1C1C1E);

    return LayoutBuilder(
      builder: (context, constraints) {
        const maxCardWidth = 480.0;
        final maxHeight = constraints.maxHeight;
        final heightScale = maxHeight.isFinite
            ? (maxHeight / 520).clamp(0.75, 1.0)
            : 1.0;

        final cardPadding = DesignTokens.spacingXl * heightScale;
        final lyricFontSize = baseLyricFontSize * heightScale.clamp(0.8, 1.0);

        final content = Text(
          totalText,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: lyricFontSize,
            height: 1.22,
            letterSpacing: -0.3,
          ),
        );

        final scaledCard = Container(
          constraints: const BoxConstraints(maxWidth: maxCardWidth),
          padding: EdgeInsets.all(cardPadding),
          decoration: BoxDecoration(
            color: cardColor.withValues(alpha: 0.90),
            borderRadius: BorderRadius.circular(21.0),
          ),
          child: content,
        );

        if (maxHeight.isFinite) {
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: scaledCard,
          );
        }

        return scaledCard;
      },
    );
  }

  Widget _buildStickerCard(
    BuildContext context,
    ThemeData theme,
    dynamic colors,
  ) {
    const textColor = Colors.white;
    final secondaryTextColor = Colors.white.withValues(alpha: 0.65);
    final totalText = lines.join('\n');
    final baseLyricFontSize = _calculateLyricFontSize(totalText.length, true);

    return LayoutBuilder(
      builder: (context, constraints) {
        const maxCardWidth = 480.0;
        final maxHeight = constraints.maxHeight;
        final heightScale = maxHeight.isFinite
            ? (maxHeight / 520).clamp(0.75, 1.0)
            : 1.0;

        final cardPadding = DesignTokens.spacingXl * heightScale;
        final albumArtSize = 88.0 * heightScale;
        final spacingAfterLyrics = DesignTokens.spacingXl * heightScale;
        final dividerSpacing = DesignTokens.spacingL * heightScale;
        final betweenMediaSpacing = DesignTokens.spacingM * heightScale;
        final titleFontSize = 26.0 * heightScale;
        final artistFontSize = 22.0 * heightScale;
        final lyricFontSize = baseLyricFontSize * heightScale.clamp(0.8, 1.0);
        final spacingAfterCard = DesignTokens.spacingL * heightScale;
        final logoSize = 21.0 * heightScale;
        final logoTextSize = DesignTokens.fontSizeBodyLarge * heightScale;
        final logoPadding = DesignTokens.spacingM * heightScale;

        final cardContent = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              totalText,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w700,
                fontSize: lyricFontSize,
                height: 1.22,
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(height: spacingAfterLyrics),
            Container(
              height: DimensionTokens.dividerThickness,
              decoration: BoxDecoration(
                color: textColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(DimensionTokens.dividerThickness / 2),
              ),
            ),
            SizedBox(height: dividerSpacing),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: SizedBox(
                    width: albumArtSize,
                    height: albumArtSize,
                    child: _buildAlbumArtThumbnail(true),
                  ),
                ),
                SizedBox(width: betweenMediaSpacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                          fontSize: titleFontSize,
                          letterSpacing: -0.3,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: DesignTokens.spacingXs),
                      Text(
                        artist,
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontWeight: FontWeight.w600,
                          fontSize: artistFontSize,
                          letterSpacing: -0.2,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );

        final logoPill = Container(
          padding: EdgeInsets.symmetric(
            horizontal: logoPadding,
            vertical: logoPadding * 0.75,
          ),
          decoration: BoxDecoration(
            color: textColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusPill),
            border: Border.all(
              color: textColor.withValues(alpha: 0.2),
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (ShareConfig.useLogoAsset)
                Image.asset(
                  ShareConfig.logoAssetPath,
                  width: logoSize,
                  height: logoSize,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(
                        Icons.radio,
                        size: logoSize,
                        color: textColor,
                      ),
                )
              else
                Icon(
                  Icons.radio,
                  size: logoSize,
                  color: textColor,
                ),
              const SizedBox(width: DesignTokens.spacingS),
              Text(
                ShareConfig.appName,
                style: TextStyle(
                  color: textColor,
                  fontSize: logoTextSize,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        );

        final scaledCard = Container(
          constraints: const BoxConstraints(maxWidth: maxCardWidth),
          padding: EdgeInsets.all(cardPadding),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E).withValues(alpha: 0.90),
            borderRadius: BorderRadius.circular(21.0),
          ),
          child: cardContent,
        );

        final column = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (maxHeight.isFinite)
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: scaledCard,
              )
            else
              scaledCard,
            SizedBox(height: spacingAfterCard),
            logoPill,
          ],
        );

        return column;
      },
    );
  }

  Widget _buildCard(
    BuildContext context,
    ThemeData theme,
    dynamic colors, {
    required bool forSticker,
  }) {
    final cardColor = const Color(0xFF1C1C1E).withValues(alpha: 0.90);
    const textColor = Colors.white;
    final secondaryTextColor = Colors.white.withValues(alpha: 0.65);
    final totalText = lines.join('\n');
    final baseLyricFontSize = _calculateLyricFontSize(totalText.length, forSticker);

    return LayoutBuilder(
      builder: (context, constraints) {
        const maxCardWidth = 480.0;
        final maxHeight = constraints.maxHeight;
        final heightScale = maxHeight.isFinite
            ? (maxHeight / 520).clamp(0.75, 1.0)
            : 1.0;

        final cardPadding = DesignTokens.spacingL * heightScale;
        final albumArtSize = 72.0 * heightScale;
        final spacingAfterLyrics = DesignTokens.spacingXl * heightScale;
        final betweenMediaSpacing = DesignTokens.spacingM * heightScale;
        final titleFontSize = 22.0 * heightScale;
        final artistFontSize = 18.0 * heightScale;
        final lyricFontSize = baseLyricFontSize * heightScale.clamp(0.8, 1.0);
        const metadataRowPadding = DesignTokens.spacingL;
        final metadataRowBackground = Colors.black.withValues(alpha: 0.4);

        final content = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              totalText,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w700,
                fontSize: lyricFontSize,
                height: 1.22,
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(height: spacingAfterLyrics),
            Container(
              padding: const EdgeInsets.all(metadataRowPadding),
              decoration: BoxDecoration(
                color: metadataRowBackground,
                borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusAlbumArt),
                    child: SizedBox(
                      width: albumArtSize,
                      height: albumArtSize,
                      child: _buildAlbumArtThumbnail(forSticker),
                    ),
                  ),
                  SizedBox(width: betweenMediaSpacing),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w700,
                            fontSize: titleFontSize,
                            letterSpacing: -0.3,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: DesignTokens.spacingXs),
                        Text(
                          artist,
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontWeight: FontWeight.w600,
                            fontSize: artistFontSize,
                            letterSpacing: -0.2,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: DesignTokens.spacingS),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: DesignTokens.spacingS,
                            vertical: DesignTokens.spacingXs,
                          ),
                          decoration: BoxDecoration(
                            color: textColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(
                              DesignTokens.cornerRadiusPill,
                            ),
                            border: Border.all(
                              color: textColor.withValues(alpha: 0.2),
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (ShareConfig.useLogoAsset)
                                Image.asset(
                                  ShareConfig.logoAssetPath,
                                  width: 16.0,
                                  height: 16.0,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.radio,
                                        size: 16.0,
                                        color: textColor,
                                      ),
                                )
                              else
                                const Icon(
                                  Icons.radio,
                                  size: 16.0,
                                  color: textColor,
                                ),
                              const SizedBox(width: DesignTokens.spacingXs),
                              const Text(
                                ShareConfig.appName,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: DesignTokens.fontSizeLabelLarge,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

        final scaledCard = Container(
          constraints: const BoxConstraints(maxWidth: maxCardWidth),
          padding: EdgeInsets.all(cardPadding),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(18.0),
          ),
          child: content,
        );

        if (maxHeight.isFinite) {
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: scaledCard,
          );
        }

        return scaledCard;
      },
    );
  }

  Widget _buildAlbumArtThumbnail(bool forSticker) {
    if (albumArtUrl != null && albumArtUrl!.isNotEmpty) {
      return AppNetworkImage(
        imageUrl: albumArtUrl!,
        fit: BoxFit.cover,
        fadeInDuration: Duration.zero,
        errorWidget: (context, url, error) =>
            _buildAlbumArtFallback(forSticker),
        placeholder: (context, url) => _buildAlbumArtFallback(forSticker),
      );
    }
    return _buildAlbumArtFallback(forSticker);
  }

  double _calculateLyricFontSize(int totalLength, bool forSticker) {
    if (forSticker) {
      if (totalLength > 130) return 24.0;
      if (totalLength > 100) return 27.0;
      if (totalLength > 70) return 30.0;
      if (totalLength > 40) return 33.0;
      return 36.0;
    } else {
      if (totalLength > 130) return 18.0;
      if (totalLength > 100) return 20.0;
      if (totalLength > 70) return 22.0;
      if (totalLength > 40) return 24.0;
      return 26.0;
    }
  }

  Widget _buildAlbumArtFallback(bool forSticker) {
    final size = forSticker ? 88.0 : 72.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1)),
      child: Image.asset(
        RadioConfig.fallbackArtworkPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.music_note,
          size: forSticker ? 40.0 : 36.0,
          color: Colors.white.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
