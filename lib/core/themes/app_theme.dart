import 'package:flutter/material.dart';
import 'app_color_system.dart';
import 'design_tokens.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final semanticColors = AppColorSystem.instance.light;
    final colorScheme = semanticColors.colorScheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: semanticColors.primaryBackground,
      textTheme: _buildTextTheme(colorScheme, Brightness.light),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        color: semanticColors.cardBackground,
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 3,
        surfaceTintColor: colorScheme.surfaceTint,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
          fontFamily: 'Inter',
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(40, 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      sliderTheme: SliderThemeData(
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        trackHeight: 4,
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.surfaceContainerHighest,
        thumbColor: colorScheme.primary,
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
      ),
    );
  }

  static ThemeData get darkTheme {
    final semanticColors = AppColorSystem.instance.dark;
    final colorScheme = semanticColors.colorScheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: semanticColors.primaryBackground,
      textTheme: _buildTextTheme(colorScheme, Brightness.dark),
      cardTheme: CardThemeData(
        elevation: DesignTokens.elevationCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
        ),
        clipBehavior: Clip.antiAlias,
        color: semanticColors.cardBackground,
        margin: EdgeInsets.zero,
        shadowColor: Colors.black.withValues(alpha: 0.3),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 3,
        surfaceTintColor: colorScheme.surfaceTint,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
          fontFamily: 'Inter',
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(40, 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      sliderTheme: SliderThemeData(
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        trackHeight: 4,
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.surfaceContainerHighest,
        thumbColor: colorScheme.primary,
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
      ),
    );
  }

  /// Build Material 3 Typography Scale
  static TextTheme _buildTextTheme(
    ColorScheme colorScheme,
    Brightness brightness,
  ) {
    return TextTheme(
      // Display styles (for large headlines)
      displayLarge: TextStyle(
        fontSize: 53,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        color: colorScheme.onSurface,
        fontFamily: 'Inter',
      ),
      displayMedium: TextStyle(
        fontSize: 41,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: colorScheme.onSurface,
        fontFamily: 'Inter',
      ),
      displaySmall: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: colorScheme.onSurface,
        fontFamily: 'Inter',
      ),

      // Headline styles (for section headers) - M3 Expressive
      headlineLarge: TextStyle(
        fontSize: DesignTokens.fontSizeH1,
        fontWeight: DesignTokens.fontWeightH1,
        letterSpacing: 0,
        color: colorScheme.onSurface,
        fontFamily: 'Inter',
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: colorScheme.onSurface,
        fontFamily: 'Inter',
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: colorScheme.onSurface,
        fontFamily: 'Inter',
      ),

      // Title styles (for card titles) - M3 Expressive
      titleLarge: TextStyle(
        fontSize: DesignTokens.fontSizeNumbers,
        fontWeight: DesignTokens.fontWeightNumbers,
        letterSpacing: 0,
        color: colorScheme.onSurface,
        fontFamily: 'Inter',
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        color: colorScheme.onSurface,
        fontFamily: 'Inter',
      ),
      titleSmall: TextStyle(
        fontSize: DesignTokens.fontSizeH2,
        fontWeight: DesignTokens.fontWeightH2,
        letterSpacing: 0.1,
        color: colorScheme.onSurface,
        fontFamily: 'Inter',
      ),

      // Body styles (for content text) - M3 Expressive
      bodyLarge: TextStyle(
        fontSize: DesignTokens.fontSizeBody,
        fontWeight: DesignTokens.fontWeightBody,
        letterSpacing: 0.5,
        color: colorScheme.onSurface,
        fontFamily: 'Inter',
      ),
      bodyMedium: TextStyle(
        fontSize: DesignTokens.fontSizeCaption,
        fontWeight: DesignTokens.fontWeightCaption,
        letterSpacing: 0.25,
        color: colorScheme.onSurface,
        fontFamily: 'Inter',
      ),
      bodySmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: colorScheme.onSurfaceVariant,
        fontFamily: 'Inter',
      ),

      // Label styles (for buttons, labels)
      labelLarge: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: colorScheme.onSurface,
        fontFamily: 'Inter',
      ),
      labelMedium: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: colorScheme.onSurface,
        fontFamily: 'Inter',
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: colorScheme.onSurface,
        fontFamily: 'Inter',
      ),
    );
  }
}
