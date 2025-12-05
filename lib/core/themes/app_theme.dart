import 'package:flutter/material.dart';
import 'app_color_system.dart';
import 'design_tokens.dart';
import 'linear_indicator_theme.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final semanticColors = AppColorSystem.instance.light;
    final colorScheme = semanticColors.colorScheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      extensions: <ThemeExtension<dynamic>>[
        LinearIndicatorThemeData.fromScheme(colorScheme),
      ],
      fontFamily: 'Inter',
      scaffoldBackgroundColor: semanticColors.primaryBackground,
      textTheme: _buildTextTheme(colorScheme, Brightness.light),
      cardTheme: CardThemeData(
        elevation: DesignTokens.elevationCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
        ),
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
          fontSize: DesignTokens.fontSizeAppBarTitle,
          fontWeight: DesignTokens.fontWeightAppBarTitle,
          letterSpacing: DesignTokens.letterSpacingAppBarTitle,
          color: colorScheme.onSurface,
          fontFamily: 'Inter',
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingL,
            vertical: DesignTokens.spacingM,
          ),
          shape: const StadiumBorder(),
          textStyle: TextStyle(
            fontSize: DesignTokens.fontSizeLabelLarge,
            fontWeight: DesignTokens.fontWeightLabelLarge,
            letterSpacing: DesignTokens.letterSpacingLabelLarge,
            fontFamily: 'Inter',
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingL,
            vertical: DesignTokens.spacingM,
          ),
          shape: const StadiumBorder(),
          textStyle: TextStyle(
            fontSize: DesignTokens.fontSizeLabelLarge,
            fontWeight: DesignTokens.fontWeightLabelLarge,
            letterSpacing: DesignTokens.letterSpacingLabelLarge,
            fontFamily: 'Inter',
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingM,
            vertical: DesignTokens.spacingS,
          ),
          shape: const StadiumBorder(),
          textStyle: TextStyle(
            fontSize: DesignTokens.fontSizeBodyMedium,
            fontWeight: DesignTokens.fontWeightLabelLarge,
            letterSpacing: DesignTokens.letterSpacingLabelLarge,
            fontFamily: 'Inter',
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: Size(DesignTokens.spacingXl * 2.5, DesignTokens.spacingXl * 2.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.spacingS),
          ),
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
      extensions: <ThemeExtension<dynamic>>[
        LinearIndicatorThemeData.fromScheme(colorScheme),
      ],
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
          fontSize: DesignTokens.fontSizeAppBarTitle,
          fontWeight: DesignTokens.fontWeightAppBarTitle,
          letterSpacing: DesignTokens.letterSpacingAppBarTitle,
          color: colorScheme.onSurface,
          fontFamily: 'Inter',
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingL,
            vertical: DesignTokens.spacingM,
          ),
          shape: const StadiumBorder(),
          textStyle: TextStyle(
            fontSize: DesignTokens.fontSizeLabelLarge,
            fontWeight: DesignTokens.fontWeightLabelLarge,
            letterSpacing: DesignTokens.letterSpacingLabelLarge,
            fontFamily: 'Inter',
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingL,
            vertical: DesignTokens.spacingM,
          ),
          shape: const StadiumBorder(),
          textStyle: TextStyle(
            fontSize: DesignTokens.fontSizeLabelLarge,
            fontWeight: DesignTokens.fontWeightLabelLarge,
            letterSpacing: DesignTokens.letterSpacingLabelLarge,
            fontFamily: 'Inter',
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingM,
            vertical: DesignTokens.spacingS,
          ),
          shape: const StadiumBorder(),
          textStyle: TextStyle(
            fontSize: DesignTokens.fontSizeBodyMedium,
            fontWeight: DesignTokens.fontWeightLabelLarge,
            letterSpacing: DesignTokens.letterSpacingLabelLarge,
            fontFamily: 'Inter',
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: Size(DesignTokens.spacingXl * 2.5, DesignTokens.spacingXl * 2.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.spacingS),
          ),
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

  /// Build Material 3 Expressive Typography Scale
  static TextTheme _buildTextTheme(
    ColorScheme colorScheme,
    Brightness brightness,
  ) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: DesignTokens.fontSizeDisplayLarge,
        fontWeight: DesignTokens.fontWeightDisplay,
        letterSpacing: DesignTokens.letterSpacingDisplayLarge,
        color: colorScheme.onSurface,
        fontFamily: 'Inter',
      ),
      displayMedium: TextStyle(
        fontSize: DesignTokens.fontSizeDisplayMedium,
        fontWeight: DesignTokens.fontWeightDisplay,
        letterSpacing: DesignTokens.letterSpacingDisplayMedium,
        color: colorScheme.onSurface,
        fontFamily: 'Inter',
      ),
      displaySmall: TextStyle(
        fontSize: DesignTokens.fontSizeDisplaySmall,
        fontWeight: DesignTokens.fontWeightDisplay,
        letterSpacing: DesignTokens.letterSpacingDisplaySmall,
        color: colorScheme.onSurface,
        fontFamily: 'Inter',
      ),
      headlineLarge: TextStyle(
        fontSize: DesignTokens.fontSizeHeadlineLarge,
        fontWeight: DesignTokens.fontWeightHeadline,
        letterSpacing: DesignTokens.letterSpacingHeadline,
        color: colorScheme.onSurface,
        fontFamily: 'Inter',
      ),
      headlineMedium: TextStyle(
        fontSize: DesignTokens.fontSizeHeadlineMedium,
        fontWeight: DesignTokens.fontWeightHeadline,
        letterSpacing: DesignTokens.letterSpacingHeadline,
        color: colorScheme.onSurface,
        fontFamily: 'Inter',
      ),
      headlineSmall: TextStyle(
        fontSize: DesignTokens.fontSizeHeadlineSmall,
        fontWeight: DesignTokens.fontWeightHeadline,
        letterSpacing: DesignTokens.letterSpacingHeadline,
        color: colorScheme.onSurface,
        fontFamily: 'Inter',
      ),
      titleLarge: TextStyle(
        fontSize: DesignTokens.fontSizeTitleLarge,
        fontWeight: DesignTokens.fontWeightTitleLarge,
        letterSpacing: DesignTokens.letterSpacingTitleLarge,
        color: colorScheme.onSurface,
        fontFamily: 'Inter',
      ),
      titleMedium: TextStyle(
        fontSize: DesignTokens.fontSizeTitleMedium,
        fontWeight: DesignTokens.fontWeightTitleMedium,
        letterSpacing: DesignTokens.letterSpacingTitleMedium,
        color: colorScheme.onSurface,
        fontFamily: 'Inter',
      ),
      titleSmall: TextStyle(
        fontSize: DesignTokens.fontSizeTitleSmall,
        fontWeight: DesignTokens.fontWeightTitleSmall,
        letterSpacing: DesignTokens.letterSpacingTitleSmall,
        color: colorScheme.onSurface,
        fontFamily: 'Inter',
      ),
      bodyLarge: TextStyle(
        fontSize: DesignTokens.fontSizeBodyLarge,
        fontWeight: DesignTokens.fontWeightBody,
        letterSpacing: DesignTokens.letterSpacingBodyLarge,
        color: colorScheme.onSurface,
        fontFamily: 'Inter',
      ),
      bodyMedium: TextStyle(
        fontSize: DesignTokens.fontSizeBodyMedium,
        fontWeight: DesignTokens.fontWeightBody,
        letterSpacing: DesignTokens.letterSpacingBodyMedium,
        color: colorScheme.onSurface,
        fontFamily: 'Inter',
      ),
      bodySmall: TextStyle(
        fontSize: DesignTokens.fontSizeBodySmall,
        fontWeight: DesignTokens.fontWeightBody,
        letterSpacing: DesignTokens.letterSpacingBodySmall,
        color: colorScheme.onSurfaceVariant,
        fontFamily: 'Inter',
      ),
      labelLarge: TextStyle(
        fontSize: DesignTokens.fontSizeLabelLarge,
        fontWeight: DesignTokens.fontWeightLabelLarge,
        letterSpacing: DesignTokens.letterSpacingLabelLarge,
        color: colorScheme.onSurface,
        fontFamily: 'Inter',
      ),
      labelMedium: TextStyle(
        fontSize: DesignTokens.fontSizeLabelMedium,
        fontWeight: DesignTokens.fontWeightLabelMedium,
        letterSpacing: DesignTokens.letterSpacingLabelMedium,
        color: colorScheme.onSurface,
        fontFamily: 'Inter',
      ),
      labelSmall: TextStyle(
        fontSize: DesignTokens.fontSizeLabelSmall,
        fontWeight: DesignTokens.fontWeightLabelSmall,
        letterSpacing: DesignTokens.letterSpacingLabelSmall,
        color: colorScheme.onSurface,
        fontFamily: 'Inter',
      ),
    );
  }
}
