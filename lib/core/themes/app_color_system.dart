import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

import '../../config/app_config.dart';

class AppColorSystem {
  AppColorSystem._({
    required this.seedColor,
    required this.light,
    required this.dark,
  });

  factory AppColorSystem._fromSeed(Color seedColor) {
    return AppColorSystem._(
      seedColor: seedColor,
      light: AppSemanticColors._from(seedColor, Brightness.light),
      dark: AppSemanticColors._from(seedColor, Brightness.dark),
    );
  }

  static final AppColorSystem instance = AppColorSystem._fromSeed(
    AppConfig.primaryColor,
  );

  static AppColorSystem fromDynamicSeed(Color? dynamicSeed) {
    return AppColorSystem._fromSeed(
      dynamicSeed ?? AppConfig.primaryColor,
    );
  }

  final Color seedColor;
  final AppSemanticColors light;
  final AppSemanticColors dark;

  AppSemanticColors byBrightness(Brightness brightness) {
    return brightness == Brightness.dark ? dark : light;
  }
}

class AppSemanticColors {
  AppSemanticColors._({
    required this.brightness,
    required this.colorScheme,
    required this.tonalPalettes,
    required this.gradientStart,
    required this.gradientEnd,
    required this.primaryBackground,
    required this.cardBackground,
    required this.primaryAccent,
    required this.secondaryAccent,
    required this.textPrimary,
    required this.textSecondary,
    required this.borderSubtle,
    required this.navBackground,
    required this.navIconSelected,
    required this.navIconUnselected,
    required this.advanced,
    required this.surfaces,
    required this.gradients,
  });

  factory AppSemanticColors._from(Color seedColor, Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
    final tonalPalettes = AppTonalPalettes.fromSeed(seedColor);
    final isLight = brightness == Brightness.light;
    final gradientStart = tonalPalettes.primaryTone(isLight ? 40 : 80);
    final gradientEnd = tonalPalettes.primaryTone(isLight ? 60 : 30);
    final navBackground = isLight
        ? colorScheme.surfaceContainerHigh
        : colorScheme.surfaceContainerHighest;

    return AppSemanticColors._(
      brightness: brightness,
      colorScheme: colorScheme,
      tonalPalettes: tonalPalettes,
      gradientStart: gradientStart,
      gradientEnd: gradientEnd,
      primaryBackground: colorScheme.surface,
      cardBackground: colorScheme.surfaceContainer,
      primaryAccent: colorScheme.tertiary,
      secondaryAccent: colorScheme.secondary,
      textPrimary: colorScheme.onSurface,
      textSecondary: colorScheme.onSurfaceVariant,
      borderSubtle: colorScheme.outlineVariant,
      navBackground: navBackground,
      navIconSelected: colorScheme.primary,
      navIconUnselected: colorScheme.onSurfaceVariant,
      advanced: AppAdvancedColors.from(colorScheme, tonalPalettes),
      surfaces: AppSurfaceColors.from(colorScheme),
      gradients: AppGradientColors.from(tonalPalettes, brightness),
    );
  }

  final Brightness brightness;
  final ColorScheme colorScheme;
  final AppTonalPalettes tonalPalettes;
  final Color gradientStart;
  final Color gradientEnd;
  final Color primaryBackground;
  final Color cardBackground;
  final Color primaryAccent;
  final Color secondaryAccent;
  final Color textPrimary;
  final Color textSecondary;
  final Color borderSubtle;
  final Color navBackground;
  final Color navIconSelected;
  final Color navIconUnselected;
  final AppAdvancedColors advanced;
  final AppSurfaceColors surfaces;
  final AppGradientColors gradients;
}

class AppAdvancedColors {
  AppAdvancedColors._({
    required this.primaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixed,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixed,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixed,
    required this.onTertiaryFixedVariant,
  });

  factory AppAdvancedColors.from(
    ColorScheme colorScheme,
    AppTonalPalettes palettes,
  ) {
    return AppAdvancedColors._(
      primaryFixed: palettes.primaryTone(90),
      primaryFixedDim: palettes.primaryTone(80),
      onPrimaryFixed: palettes.primaryTone(10),
      onPrimaryFixedVariant: palettes.primaryTone(30),
      secondaryFixed: palettes.secondaryTone(90),
      secondaryFixedDim: palettes.secondaryTone(80),
      onSecondaryFixed: palettes.secondaryTone(10),
      onSecondaryFixedVariant: palettes.secondaryTone(30),
      tertiaryFixed: palettes.tertiaryTone(90),
      tertiaryFixedDim: palettes.tertiaryTone(80),
      onTertiaryFixed: palettes.tertiaryTone(10),
      onTertiaryFixedVariant: palettes.tertiaryTone(30),
    );
  }

  final Color primaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixed;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixed;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixed;
  final Color onTertiaryFixedVariant;
}

class AppSurfaceColors {
  AppSurfaceColors._({
    required this.surfaceBright,
    required this.surfaceDim,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.inverseSurface,
    required this.inverseOnSurface,
  });

  factory AppSurfaceColors.from(ColorScheme colorScheme) {
    return AppSurfaceColors._(
      surfaceBright: colorScheme.surfaceBright,
      surfaceDim: colorScheme.surfaceDim,
      surfaceContainerLowest: colorScheme.surfaceContainerLowest,
      surfaceContainerLow: colorScheme.surfaceContainerLow,
      surfaceContainer: colorScheme.surfaceContainer,
      surfaceContainerHigh: colorScheme.surfaceContainerHigh,
      surfaceContainerHighest: colorScheme.surfaceContainerHighest,
      inverseSurface: colorScheme.inverseSurface,
      inverseOnSurface: colorScheme.onInverseSurface,
    );
  }

  final Color surfaceBright;
  final Color surfaceDim;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color inverseSurface;
  final Color inverseOnSurface;
}

class AppGradientColors {
  AppGradientColors._({
    required this.primaryHeroStart,
    required this.primaryHeroEnd,
    required this.accentOverlayStart,
    required this.accentOverlayEnd,
    required this.neutralScrim,
    required this.surfaceGlow,
  });

  factory AppGradientColors.from(
    AppTonalPalettes palettes,
    Brightness brightness,
  ) {
    final isLight = brightness == Brightness.light;
    return AppGradientColors._(
      primaryHeroStart: palettes.primaryTone(isLight ? 35 : 80),
      primaryHeroEnd: palettes.primaryTone(isLight ? 60 : 30),
      accentOverlayStart: palettes.secondaryTone(isLight ? 40 : 80),
      accentOverlayEnd: palettes.secondaryTone(isLight ? 60 : 40),
      neutralScrim: palettes.neutralTone(isLight ? 10 : 90).withValues(
        alpha: isLight ? 0.75 : 0.6,
      ),
      surfaceGlow: palettes.neutralVariantTone(isLight ? 90 : 20).withValues(
        alpha: isLight ? 0.4 : 0.3,
      ),
    );
  }

  final Color primaryHeroStart;
  final Color primaryHeroEnd;
  final Color accentOverlayStart;
  final Color accentOverlayEnd;
  final Color neutralScrim;
  final Color surfaceGlow;
}

class AppTonalPalettes {
  AppTonalPalettes._({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.neutral,
    required this.neutralVariant,
    required this.error,
  });

  factory AppTonalPalettes.fromSeed(Color seedColor) {
    final cam = Cam16.fromInt(seedColor.toARGB32());
    final primaryChroma = math.max(48.0, math.min(cam.chroma.toDouble(), 120.0));
    return AppTonalPalettes._(
      primary: TonalPalette.of(cam.hue, primaryChroma),
      secondary: TonalPalette.of(cam.hue, math.max(16.0, primaryChroma * 0.3)),
      tertiary: TonalPalette.of(cam.hue + 60, math.max(24.0, primaryChroma * 0.5)),
      neutral: TonalPalette.of(cam.hue, 4),
      neutralVariant: TonalPalette.of(cam.hue, 8),
      error: TonalPalette.of(25, 84),
    );
  }

  final TonalPalette primary;
  final TonalPalette secondary;
  final TonalPalette tertiary;
  final TonalPalette neutral;
  final TonalPalette neutralVariant;
  final TonalPalette error;

  Color primaryTone(int tone) => Color(primary.get(tone));
  Color secondaryTone(int tone) => Color(secondary.get(tone));
  Color tertiaryTone(int tone) => Color(tertiary.get(tone));
  Color neutralTone(int tone) => Color(neutral.get(tone));
  Color neutralVariantTone(int tone) => Color(neutralVariant.get(tone));
  Color errorTone(int tone) => Color(error.get(tone));
}

extension AppColorSystemContext on BuildContext {
  AppSemanticColors get appColors {
    final theme = Theme.of(this);
    return AppColorSystem.instance.byBrightness(theme.brightness);
  }
}
