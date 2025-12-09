import 'package:flutter/material.dart';

import '../../../../config/radio_config.dart';
import '../../../../config/share_config.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/utils/palette_cache.dart';
import '../../../../core/themes/app_color_system.dart';

class LyricShareCard extends StatelessWidget {
  final List<String> lines;
  final String artist;
  final String title;
  final String? albumArtUrl;
  final PaletteColors? palette;
  final bool isSticker;
  final bool hasBackground;

  const LyricShareCard({
    super.key,
    required this.lines,
    required this.artist,
    required this.title,
    this.albumArtUrl,
    this.palette,
    this.isSticker = false,
    this.hasBackground = false,
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
          child: _buildCard(context, theme, colors, forSticker: true),
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
        child: _buildCard(context, theme, colors, forSticker: true),
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
            Opacity(
              opacity: 0.35,
              child: Transform.scale(
                scale: 1.3,
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
    final lyricFontSize = _calculateLyricFontSize(totalText.length, forSticker);

    const maxCardWidth = 480.0;
    final cardPadding = forSticker ? 27.0 : 20.0;
    final albumArtSize = forSticker ? 66.0 : 48.0;
    const brandTextColor = Colors.white;
    const brandIconBg = Colors.white;
    const brandIconColor = Colors.black;
    final brandCircleSize = forSticker ? 30.0 : 26.0;
    final brandIconSize = forSticker ? 16.0 : 14.0;
    final brandSpacing = forSticker ? 8.0 : 6.0;
    final brandTextSize = forSticker ? 16.0 : 14.0;
    final brandLetterSpacing = forSticker ? 0.8 : 0.6;

    return Container(
      constraints: const BoxConstraints(maxWidth: maxCardWidth),
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(forSticker ? 21.0 : 18.0),
      ),
      child: Column(
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

          SizedBox(height: forSticker ? 21.0 : 18.0),

          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(forSticker ? 8.0 : 6.0),
                child: SizedBox(
                  width: albumArtSize,
                  height: albumArtSize,
                  child: _buildAlbumArtThumbnail(forSticker),
                ),
              ),

              SizedBox(width: forSticker ? 15.0 : 12.0),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: forSticker ? 20.0 : 15.0,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      artist,
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: forSticker ? 17.0 : 13.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: brandCircleSize,
                          height: brandCircleSize,
                          decoration: const BoxDecoration(
                            color: brandIconBg,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: ShareConfig.useLogoAsset
                                ? Image.asset(
                                    ShareConfig.logoAssetPath,
                                    width: brandIconSize,
                                    height: brandIconSize,
                                    fit: BoxFit.contain,
                                    color: brandIconColor,
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                          Icons.music_note_rounded,
                                          size: brandIconSize,
                                          color: brandIconColor,
                                        ),
                                  )
                                : Icon(
                                    Icons.music_note_rounded,
                                    size: brandIconSize,
                                    color: brandIconColor,
                                  ),
                          ),
                        ),
                        SizedBox(width: brandSpacing),
                        Text(
                          ShareConfig.appName,
                          style: TextStyle(
                            color: brandTextColor,
                            fontSize: brandTextSize,
                            fontWeight: FontWeight.w700,
                            letterSpacing: brandLetterSpacing,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
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
    final size = forSticker ? 66.0 : 52.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1)),
      child: Image.asset(
        RadioConfig.fallbackArtworkPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.music_note,
          size: forSticker ? 30.0 : 24.0,
          color: Colors.white.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
