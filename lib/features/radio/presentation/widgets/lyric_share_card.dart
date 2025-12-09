import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../config/radio_config.dart';
import '../../../../config/share_config.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/utils/palette_cache.dart';

class LyricShareCard extends StatelessWidget {
  final List<String> lines;
  final String artist;
  final String title;
  final String? albumArtUrl;
  final PaletteColors? palette;
  final bool isSticker;

  const LyricShareCard({
    super.key,
    required this.lines,
    required this.artist,
    required this.title,
    this.albumArtUrl,
    this.palette,
    this.isSticker = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final effectivePalette = palette;
    final topColor = effectivePalette?.vibrant ?? effectivePalette?.dominant ?? colors.surfaces.surfaceContainerHighest;
    final bottomColor = effectivePalette?.darkVibrant ?? effectivePalette?.muted ?? colors.surfaces.surfaceContainerHighest.withValues(alpha: 0.8);
    final overlayColor = Colors.black.withValues(alpha: isSticker ? 0.35 : 0.4);
    final cardColor = Colors.white.withValues(alpha: isSticker ? 0.82 : 0.78);
    final textColor = Colors.black.withValues(alpha: 0.92);
    final accentColor = effectivePalette?.vibrant ?? colors.textPrimary;
    final lineStyle = TextStyle(
      color: textColor,
      fontWeight: FontWeight.w700,
      fontSize: isSticker ? 18 : 20,
      height: 1.3,
      letterSpacing: -0.1,
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            topColor,
            bottomColor,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: (albumArtUrl != null && albumArtUrl!.isNotEmpty)
                        ? buildAppNetworkImageProvider(albumArtUrl!)
                        : AssetImage(RadioConfig.fallbackArtworkPath) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    overlayColor,
                    overlayColor.withValues(alpha: isSticker ? 0.55 : 0.6),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSticker ? DesignTokens.spacingM : DesignTokens.spacingL,
                vertical: isSticker ? DesignTokens.spacingL : DesignTokens.spacingXl,
              ),
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxWidth: isSticker ? 460 : 540,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingL,
                  vertical: isSticker ? DesignTokens.spacingL : DesignTokens.spacingXl,
                ),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(
                    isSticker ? DesignTokens.cornerRadiusCard : DesignTokens.cornerRadiusCard,
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.22),
                    width: DimensionTokens.borderWidthThin,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.14),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: DesignTokens.spacingS,
                      runSpacing: DesignTokens.spacingXs,
                      children: lines
                          .map(
                            (line) => Text(
                              line.trim(),
                              style: lineStyle,
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: DesignTokens.spacingL),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: isSticker ? 16 : 18,
                                  letterSpacing: -0.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: DesignTokens.spacingXs),
                              Text(
                                artist,
                                style: TextStyle(
                                  color: textColor.withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w600,
                                  fontSize: isSticker ? 14 : 15,
                                  letterSpacing: -0.15,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: DesignTokens.spacingM),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: DesignTokens.spacingS,
                            vertical: DesignTokens.spacingXs,
                          ),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusPill),
                            border: Border.all(
                              color: accentColor.withValues(alpha: 0.35),
                              width: DimensionTokens.borderWidthThin,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.music_note,
                                size: 14,
                                color: textColor,
                              ),
                              const SizedBox(width: DesignTokens.spacingXs),
                              Text(
                                ShareConfig.appName,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: DesignTokens.fontSizeLabelSmall,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

