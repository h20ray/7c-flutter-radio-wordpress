import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../config/share_config.dart';
import '../../../../config/radio_config.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/utils/palette_cache.dart';

class RadioShareCard extends StatelessWidget {
  final String? artist;
  final String? title;
  final String? albumArtUrl;
  final PaletteColors? palette;
  final bool isPlaying;

  const RadioShareCard({
    super.key,
    this.artist,
    this.title,
    this.albumArtUrl,
    this.palette,
    this.isPlaying = false,
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
    const maxLines = 3;
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

    final backgroundColor = _getBackgroundColor(context);
    final textColor = _getTextColor(context);
    final secondaryTextColor = _getSecondaryTextColor(context);

    final displayTitle = title?.trim().isNotEmpty == true
        ? title!.trim()
        : RadioConfig.fallbackTitle;
    final displayArtist = artist?.trim().isNotEmpty == true
        ? artist!.trim()
        : RadioConfig.fallbackArtist;

    final String backgroundImageUrl = albumArtUrl ?? RadioConfig.fallbackArtworkPath;
    final bool isNetworkImage = albumArtUrl != null && albumArtUrl!.isNotEmpty;

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
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: textColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: textColor.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: textColor,
                            shape: BoxShape.circle,
                          ),
                          child: ShareConfig.useLogoAsset
                              ? Image.asset(
                                  ShareConfig.logoAssetPath,
                                  width: 10,
                                  height: 10,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
                                    Icons.radio,
                                    color: textColor == Colors.black87 
                                        ? Colors.white 
                                        : (textColor == Colors.white ? Colors.black87 : backgroundColor),
                                    size: 10,
                                  ),
                                )
                              : Icon(
                                  Icons.radio,
                                  color: textColor == Colors.black87 
                                      ? Colors.white 
                                      : (textColor == Colors.white ? Colors.black87 : backgroundColor),
                                  size: 10,
                                ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          ShareConfig.appName,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
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
                                      maxWidth: constraints.maxWidth * 0.6,
                                      maxHeight: constraints.maxWidth * 0.6,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.3),
                                          blurRadius: 24,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
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
                                                  size: 60,
                                                  color: Colors.grey[400],
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: _buildAdaptiveTitle(
                                    context: context,
                                    theme: theme,
                                    textColor: textColor,
                                    displayTitle: displayTitle,
                                    maxWidth: constraints.maxWidth - 16,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
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

                const SizedBox(height: 16),

                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: textColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: textColor.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.play_circle_filled,
                          color: textColor,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Now Playing on ${ShareConfig.appNameFull}',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
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
}

