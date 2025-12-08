import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../config/radio_config.dart';
import '../../../../config/share_config.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/utils/palette_cache.dart';
import '../../../../core/widgets/app_network_image.dart';

/// Full-bleed 9:16 canvas for regular shares (WhatsApp/Snapchat/etc.).
/// Uses a proper full-bleed layout with album art taking up most of the space
/// and song info at the bottom to avoid ugly black bars.
class RadioShareRegularCanvas extends StatelessWidget {
  final String? artist;
  final String? title;
  final String? albumArtUrl;
  final PaletteColors? palette;
  final bool isPlaying;

  const RadioShareRegularCanvas({
    super.key,
    this.artist,
    this.title,
    this.albumArtUrl,
    this.palette,
    this.isPlaying = false,
  });

  List<Color> _gradientColors(ThemeData theme) {
    if (palette != null) {
      return [
        palette!.vibrant.withValues(alpha: 0.5),
        palette!.darkVibrant.withValues(alpha: 0.7),
      ];
    }
    final scheme = theme.colorScheme;
    return [
      scheme.primary.withValues(alpha: 0.4),
      scheme.secondary.withValues(alpha: 0.5),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);
    const fallbackArtwork = RadioConfig.fallbackArtworkPath;
    final imageUrl = albumArtUrl ?? fallbackArtwork;
    final hasNetwork = albumArtUrl != null && albumArtUrl!.isNotEmpty;
    final gradientColors = _gradientColors(theme);

    final displayTitle = title?.trim().isNotEmpty == true
        ? title!.trim()
        : RadioConfig.fallbackTitle;
    final displayArtist = artist?.trim().isNotEmpty == true
        ? artist!.trim()
        : RadioConfig.fallbackArtist;

    return AspectRatio(
      aspectRatio: 9 / 16,
      child: Container(
        color: colors.primaryBackground,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Blurred album art background
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Transform.scale(
                  scale: 1.2, // Prevent blur edge artifacts
                  child: hasNetwork
                      ? AppNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          fadeInDuration: Duration.zero,
                        )
                      : Image.asset(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: colors.primaryBackground),
                        ),
                ),
              ),
            ),
            // Palette-driven gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: gradientColors,
                  ),
                ),
              ),
            ),
            // Subtle scrim for readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.1),
                      Colors.black.withValues(alpha: 0.5),
                    ],
                  ),
                ),
              ),
            ),
            // Main content layout - fills the entire canvas properly
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final canvasWidth = constraints.maxWidth;
                  final canvasHeight = constraints.maxHeight;
                  
                  // Album art takes up ~72% of canvas width, centered horizontally
                  final albumArtSize = canvasWidth * 0.72;
                  // Position album art in the upper portion of the canvas
                  final albumArtTop = canvasHeight * 0.12;
                  
                   final titleFontSize = (albumArtSize * 0.085).clamp(24.0, 32.0);
                   final artistFontSize = (titleFontSize * 0.7).clamp(16.0, 22.0);

                   return Stack(
                    children: [
                      // Album art + song info grouped together
                      Positioned(
                        top: albumArtTop,
                        left: (canvasWidth - albumArtSize) / 2,
                        right: (canvasWidth - albumArtSize) / 2,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Large centered album art with shadow
                            Container(
                              width: albumArtSize,
                              height: albumArtSize,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  DesignTokens.cornerRadiusAlbumArt,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    blurRadius: 40,
                                    spreadRadius: 5,
                                    offset: const Offset(0, 15),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  DesignTokens.cornerRadiusAlbumArt,
                                ),
                                child: hasNetwork
                                    ? AppNetworkImage(
                                        imageUrl: imageUrl,
                                        fit: BoxFit.cover,
                                        fadeInDuration: Duration.zero,
                                      )
                                    : Image.asset(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            Container(
                                          color: colors.surfaces.surfaceContainerHighest,
                                          child: Icon(
                                            Icons.music_note,
                                            size: albumArtSize * 0.3,
                                            color: colors.textSecondary,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: DesignTokens.spacingL),
                            // Song title - directly below album art
                            Text(
                              displayTitle,
                               style: TextStyle(
                                 color: Colors.white,
                                 fontWeight: FontWeight.bold,
                                 fontSize: titleFontSize,
                                 letterSpacing: -0.5,
                                 height: 1.2,
                                 shadows: const [
                                  Shadow(
                                    color: Colors.black54,
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: DesignTokens.spacingXs),
                            // Artist name
                            Text(
                              displayArtist,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontWeight: FontWeight.w500,
                                 fontSize: artistFontSize,
                                letterSpacing: -0.3,
                                height: 1.2,
                                shadows: const [
                                  Shadow(
                                    color: Colors.black54,
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // App branding badge at the bottom
                      Positioned(
                        bottom: canvasHeight * 0.06,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: DesignTokens.spacingM,
                              vertical: DesignTokens.spacingS,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(
                                DesignTokens.cornerRadiusPill,
                              ),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (ShareConfig.useLogoAsset)
                                  Image.asset(
                                    ShareConfig.logoAssetPath,
                                    width: 16,
                                    height: 16,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(
                                      Icons.radio,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  )
                                else
                                  const Icon(
                                    Icons.radio,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                const SizedBox(width: DesignTokens.spacingS),
                                const Text(
                                  ShareConfig.appName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

