import 'dart:math' as math;
import 'dart:ui';
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
  final bool isStickerFormat;

  const RadioShareCard({
    super.key,
    this.artist,
    this.title,
    this.albumArtUrl,
    this.palette,
    this.isPlaying = false,
    this.isStickerFormat = false,
  });

  Color _getBackgroundColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    if (palette != null) {
      return palette!.dominant;
    }
    
    // Match radio screen background logic
    return isDark ? const Color(0xFF15232B) : const Color(0xFF2C3E50);
  }

  Color _getTextColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    if (palette != null) {
      final bgColor = palette!.dominant;
      final luminance = _calculateLuminance(bgColor);
      
      if (isDark) {
        // Dark mode: prefer white text unless background is very light
        return luminance > 0.7 ? Colors.black87 : Colors.white;
      } else {
        // Light mode: prefer dark text unless background is very dark
        // Only use white text if luminance is very low (< 0.15)
        return luminance < 0.15 ? Colors.white : Colors.black87;
      }
    }
    
    // No palette: use theme-based colors
    return isDark ? Colors.white : theme.colorScheme.onSurface;
  }

  Color _getSecondaryTextColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    if (palette != null) {
      final bgColor = palette!.dominant;
      final luminance = _calculateLuminance(bgColor);
      
      if (isDark) {
        // Dark mode: prefer white text unless background is very light
        return luminance > 0.7 ? Colors.black54 : Colors.white70;
      } else {
        // Light mode: prefer dark text unless background is very dark
        // Only use white text if luminance is very low (< 0.15)
        return luminance < 0.15 ? Colors.white70 : Colors.black54;
      }
    }
    
    return isDark ? Colors.white70 : theme.colorScheme.onSurfaceVariant;
  }

  double _calculateLuminance(Color color) {
    final r = color.r / 255.0;
    final g = color.g / 255.0;
    final b = color.b / 255.0;

    final rLinear = r <= 0.03928 ? r / 12.92 : math.pow((r + 0.055) / 1.055, 2.4);
    final gLinear = g <= 0.03928 ? g / 12.92 : math.pow((g + 0.055) / 1.055, 2.4);
    final bLinear = b <= 0.03928 ? b / 12.92 : math.pow((b + 0.055) / 1.055, 2.4);

    return 0.2126 * rLinear + 0.7152 * gLinear + 0.0722 * bLinear;
  }

  Widget _buildAdaptiveTitle({
    required BuildContext context,
    required ThemeData theme,
    required Color textColor,
    required String displayTitle,
    required double maxWidth,
  }) {
    final baseFontSize = theme.textTheme.headlineSmall?.fontSize ?? 24;
    const minFontSize = 16.0;
    const lineHeight = 1.2; // Line height multiplier
    const maxLines = 2;
    final maxHeight = baseFontSize * lineHeight * maxLines;
    
    final baseStyle = theme.textTheme.headlineSmall?.copyWith(
      color: textColor,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      height: lineHeight,
    );
    
    double fontSize = baseFontSize;
    TextPainter textPainter;
    
    // Binary search for optimal font size
    double lowerBound = minFontSize;
    double upperBound = baseFontSize;
    
    while ((upperBound - lowerBound) > 0.5) {
      fontSize = (lowerBound + upperBound) / 2;
      
      textPainter = TextPainter(
        text: TextSpan(
          text: displayTitle,
          style: baseStyle?.copyWith(fontSize: fontSize),
        ),
        textDirection: TextDirection.ltr,
        maxLines: maxLines,
      );
      
      textPainter.layout(maxWidth: maxWidth);
      
      if (textPainter.didExceedMaxLines || textPainter.height > maxHeight) {
        upperBound = fontSize;
      } else {
        lowerBound = fontSize;
      }
    }
    
    // Use the lower bound (largest size that fits)
    fontSize = lowerBound.clamp(minFontSize, baseFontSize);
    
    return Text(
      displayTitle,
      style: baseStyle?.copyWith(fontSize: fontSize),
      textAlign: TextAlign.center,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final displayTitle = title?.trim().isNotEmpty == true
        ? title!.trim()
        : RadioConfig.fallbackTitle;
    final displayArtist = artist?.trim().isNotEmpty == true
        ? artist!.trim()
        : RadioConfig.fallbackArtist;

    final String backgroundImageUrl = albumArtUrl ?? RadioConfig.fallbackArtworkPath;
    final bool isNetworkImage = albumArtUrl != null && albumArtUrl!.isNotEmpty;

    if (isStickerFormat) {
      return _buildInstagramStickerCard(
        context: context,
        theme: theme,
        displayTitle: displayTitle,
        displayArtist: displayArtist,
        backgroundImageUrl: backgroundImageUrl,
        isNetworkImage: isNetworkImage,
      );
    }

    final backgroundColor = _getBackgroundColor(context);
    final textColor = _getTextColor(context);
    final secondaryTextColor = _getSecondaryTextColor(context);

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: isDark ? Colors.black : Colors.grey[900],
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (palette != null && isNetworkImage)
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: AppNetworkImage(
                  imageUrl: backgroundImageUrl,
                  fit: BoxFit.cover,
                  fadeInDuration: Duration.zero,
                ),
              ),
            )
          else if (palette == null)
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: Image.asset(
                  RadioConfig.fallbackArtworkPath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: isDark ? Colors.black : Colors.grey[900],
                  ),
                ),
              ),
            ),

          if (palette != null)
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topLeft,
                      radius: 1.5,
                      colors: [
                        palette!.vibrant.withValues(alpha: 0.3),
                        palette!.darkVibrant.withValues(alpha: 0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

          Container(
            color: theme.scaffoldBackgroundColor.withValues(alpha: 0.7),
          ),

          Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingXl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.all(DesignTokens.spacingS),
                    decoration: BoxDecoration(
                      color: textColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
                      border: Border.all(
                        color: textColor.withValues(alpha: 0.2),
                        width: DimensionTokens.borderWidthThin,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(DesignTokens.spacingXs / 1.33),
                          decoration: BoxDecoration(
                            color: textColor,
                            shape: BoxShape.circle,
                          ),
                          child: ShareConfig.useLogoAsset
                              ? Image.asset(
                                  ShareConfig.logoAssetPath,
                                  width: DimensionTokens.iconSizeSmall * 0.625,
                                  height: DimensionTokens.iconSizeSmall * 0.625,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
                                    Icons.radio,
                                    color: textColor == Colors.black87 
                                        ? Colors.white 
                                        : (textColor == Colors.white ? Colors.black87 : backgroundColor),
                                    size: DimensionTokens.iconSizeSmall * 0.625,
                                  ),
                                )
                              : Icon(
                                  Icons.radio,
                                  color: textColor == Colors.black87 
                                      ? Colors.white 
                                      : (textColor == Colors.white ? Colors.black87 : backgroundColor),
                                  size: DimensionTokens.iconSizeSmall * 0.625,
                                ),
                        ),
                        const SizedBox(width: DesignTokens.spacingXs),
                        Text(
                          ShareConfig.appName,
                          style: TextStyle(
                            color: textColor,
                            fontSize: DesignTokens.fontSizeCaption,
                            fontWeight: DesignTokens.fontWeightCaption,
                            letterSpacing: DesignTokens.letterSpacingLabelMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: DesignTokens.spacingL),

                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final albumArtSize = constraints.maxWidth * 0.6;
                      
                      return SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: IntrinsicHeight(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: albumArtSize,
                                      maxHeight: albumArtSize,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
                                      boxShadow: AppShadowTokens.elevation8(context),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
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
                                                color: Colors.grey[800],
                                                child: Icon(
                                                  Icons.music_note,
                                                  size: DimensionTokens.iconSizeLarge * 2.5,
                                                  color: Colors.grey[400],
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: DesignTokens.spacingXl),

                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingS),
                                  child: _buildAdaptiveTitle(
                                    context: context,
                                    theme: theme,
                                    textColor: textColor,
                                    displayTitle: displayTitle,
                                    maxWidth: constraints.maxWidth - 16,
                                  ),
                                ),

                                const SizedBox(height: DesignTokens.spacingS),

                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingS),
                                  child: Text(
                                    displayArtist,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: secondaryTextColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: DesignTokens.spacingL),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingS,
                      vertical: DesignTokens.spacingXs + 1,
                    ),
                    decoration: BoxDecoration(
                      color: textColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusAlbumArt),
                      border: Border.all(
                        color: textColor.withValues(alpha: 0.2),
                        width: DimensionTokens.borderWidthThin,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.play_circle_filled,
                          color: textColor,
                          size: DesignTokens.fontSizeCaption,
                        ),
                        const SizedBox(width: DesignTokens.spacingXs),
                        Text(
                          'Now Playing on ${ShareConfig.appNameFull}',
                          style: TextStyle(
                            color: textColor,
                            fontSize: DesignTokens.fontSizeCaption,
                            fontWeight: DesignTokens.fontWeightCaption,
                            letterSpacing: DesignTokens.letterSpacingLabelSmall,
                          ),
                        ),
                      ],
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

  Widget _buildInstagramStickerCard({
    required BuildContext context,
    required ThemeData theme,
    required String displayTitle,
    required String displayArtist,
    required String backgroundImageUrl,
    required bool isNetworkImage,
  }) {
    final colors = context.appColors;
    final scheme = colors.colorScheme;
    
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.transparent,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(DesignTokens.spacingS),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusPill),
            boxShadow: AppShadowTokens.elevation8(context),
          ),
          child: Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingM),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth;
                final albumArtSize = availableWidth * 0.65;
                
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: albumArtSize,
                      height: albumArtSize,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
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
                                    color: colors.surfaces.surfaceContainerHighest,
                                    child: Icon(
                                      Icons.music_note,
                                      size: DimensionTokens.iconSizeLarge * 2,
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: DesignTokens.spacingM),
                    Text(
                      displayTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: DesignTokens.fontWeightTitleMedium,
                        fontSize: DesignTokens.fontSizeTitleSmall,
                        letterSpacing: DesignTokens.letterSpacingTitleSmall,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: DesignTokens.spacingXs),
                    Text(
                      displayArtist,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: DesignTokens.fontWeightBody,
                        fontSize: DesignTokens.fontSizeBodySmall,
                        letterSpacing: DesignTokens.letterSpacingBodySmall,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: DesignTokens.spacingM),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (ShareConfig.useLogoAsset)
                          Image.asset(
                            ShareConfig.logoAssetPath,
                            width: DimensionTokens.iconSizeSmall,
                            height: DimensionTokens.iconSizeSmall,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(
                              Icons.radio,
                              size: DimensionTokens.iconSizeSmall,
                              color: colors.textPrimary,
                            ),
                          )
                        else
                          Icon(
                            Icons.radio,
                            size: DimensionTokens.iconSizeSmall,
                            color: colors.textPrimary,
                          ),
                        const SizedBox(width: DesignTokens.spacingXs),
                        Text(
                          ShareConfig.appName,
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: DesignTokens.fontSizeLabelSmall,
                            fontWeight: DesignTokens.fontWeightLabelSmall,
                            letterSpacing: DesignTokens.letterSpacingLabelSmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

