import 'package:flutter/material.dart';

import 'app_color_system.dart';

class AppShadowTokens {
  AppShadowTokens._({
    required this.level1,
    required this.level2,
    required this.level3,
  });

  factory AppShadowTokens.of(BuildContext context) {
    final base = Theme.of(context).colorScheme.shadow;
    return AppShadowTokens._(
      level1: base.withValues(alpha: 0.08),
      level2: base.withValues(alpha: 0.12),
      level3: base.withValues(alpha: 0.18),
    );
  }

  final Color level1;
  final Color level2;
  final Color level3;

  static List<BoxShadow> elevation2(BuildContext context) {
    final shadowColor = Theme.of(context).colorScheme.shadow;
    return [
      BoxShadow(
        color: shadowColor.withValues(alpha: 0.15),
        offset: const Offset(0, 1),
        blurRadius: 3,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: shadowColor.withValues(alpha: 0.10),
        offset: const Offset(0, 0),
        blurRadius: 1,
        spreadRadius: 0,
      ),
    ];
  }

  static List<BoxShadow> elevation4(BuildContext context) {
    final shadowColor = Theme.of(context).colorScheme.shadow;
    return [
      BoxShadow(
        color: shadowColor.withValues(alpha: 0.12),
        offset: const Offset(0, 1),
        blurRadius: 3,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: shadowColor.withValues(alpha: 0.08),
        offset: const Offset(0, 0),
        blurRadius: 1,
        spreadRadius: 0,
      ),
    ];
  }

  static List<BoxShadow> elevation8(BuildContext context) {
    final shadowColor = Theme.of(context).colorScheme.shadow;
    return [
      BoxShadow(
        color: shadowColor.withValues(alpha: 0.18),
        offset: const Offset(0, 2),
        blurRadius: 6,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: shadowColor.withValues(alpha: 0.12),
        offset: const Offset(0, 0),
        blurRadius: 2,
        spreadRadius: 0,
      ),
    ];
  }
}

class HomeHeaderTokens {
  HomeHeaderTokens._({
    required this.background,
    required this.primaryText,
    required this.secondaryText,
    required this.avatarFill,
    required this.avatarBorder,
    required this.badgeBackground,
    required this.badgeText,
    required this.tileBackground,
    required this.tileIcon,
  });

  factory HomeHeaderTokens.of(BuildContext context) {
    final colors = context.appColors;
    final scheme = colors.colorScheme;
    final advanced = colors.advanced;
    final isLight = colors.brightness == Brightness.light;
    
    final background = isLight
        ? colors.tonalPalettes.primaryTone(45)
        : colors.tonalPalettes.primaryTone(65);
    
    final backgroundLuminance = background.computeLuminance();
    final needsLightText = backgroundLuminance < 0.5;
    
    final primaryTextColor = needsLightText 
        ? scheme.onPrimary 
        : scheme.onSurface;
    final secondaryTextColor = needsLightText
        ? scheme.onPrimary.withValues(alpha: 0.87)
        : scheme.onSurface.withValues(alpha: 0.7);
    
    final contrastRatio = _calculateContrastRatio(
      needsLightText ? scheme.onPrimary : scheme.onSurface,
      background,
    );
    
    final finalPrimaryText = contrastRatio >= 4.5
        ? primaryTextColor
        : needsLightText
            ? Colors.white
            : Colors.black;
    
    final finalSecondaryText = contrastRatio >= 4.5
        ? secondaryTextColor
        : needsLightText
            ? Colors.white.withValues(alpha: 0.87)
            : Colors.black.withValues(alpha: 0.7);
    
    final avatarFillColor = needsLightText
        ? finalPrimaryText.withValues(alpha: 0.12)
        : finalPrimaryText.withValues(alpha: 0.12);
    final avatarBorderColor = needsLightText
        ? finalPrimaryText.withValues(alpha: 0.24)
        : finalPrimaryText.withValues(alpha: 0.24);
    final badgeBgColor = needsLightText
        ? finalPrimaryText.withValues(alpha: 0.2)
        : finalPrimaryText.withValues(alpha: 0.15);
    
    final tileBg = isLight
        ? advanced.primaryFixed
        : advanced.primaryFixedDim;
    
    final tileBgLuminance = tileBg.computeLuminance();
    final tileNeedsLightIcon = tileBgLuminance < 0.5;
    final tileIconColor = tileNeedsLightIcon
        ? Colors.white
        : scheme.onSurface;
    
    return HomeHeaderTokens._(
      background: background,
      primaryText: finalPrimaryText,
      secondaryText: finalSecondaryText,
      avatarFill: avatarFillColor,
      avatarBorder: avatarBorderColor,
      badgeBackground: badgeBgColor,
      badgeText: finalPrimaryText,
      tileBackground: tileBg,
      tileIcon: tileIconColor,
    );
  }

  static double _calculateContrastRatio(Color foreground, Color background) {
    final fgLuminance = foreground.computeLuminance();
    final bgLuminance = background.computeLuminance();
    
    final lighter = fgLuminance > bgLuminance ? fgLuminance : bgLuminance;
    final darker = fgLuminance > bgLuminance ? bgLuminance : fgLuminance;
    
    return (lighter + 0.05) / (darker + 0.05);
  }

  final Color background;
  final Color primaryText;
  final Color secondaryText;
  final Color avatarFill;
  final Color avatarBorder;
  final Color badgeBackground;
  final Color badgeText;
  final Color tileBackground;
  final Color tileIcon;
}

class NewsFilterChipTokens {
  NewsFilterChipTokens._({
    required this.selectedBackground,
    required this.unselectedBackground,
    required this.selectedLabel,
    required this.unselectedLabel,
    required this.outline,
    required this.checkmark,
    required this.cardShadow,
  });

  factory NewsFilterChipTokens.of(BuildContext context) {
    final colors = context.appColors;
    final shadows = AppShadowTokens.of(context);
    return NewsFilterChipTokens._(
      selectedBackground: colors.advanced.primaryFixedDim,
      unselectedBackground: colors.cardBackground,
      selectedLabel: colors.advanced.onPrimaryFixed,
      unselectedLabel: colors.textPrimary,
      outline: colors.borderSubtle,
      checkmark: colors.advanced.onPrimaryFixed,
      cardShadow: shadows.level1,
    );
  }

  final Color selectedBackground;
  final Color unselectedBackground;
  final Color selectedLabel;
  final Color unselectedLabel;
  final Color outline;
  final Color checkmark;
  final Color cardShadow;
}

class NewsCardTokens {
  NewsCardTokens._({
    required this.gradientStart,
    required this.gradientEnd,
    required this.badgeBackground,
    required this.badgeText,
    required this.headline,
    required this.body,
    required this.metadata,
    required this.ctaBackground,
    required this.ctaText,
    required this.iconBackground,
    required this.iconColor,
    required this.shadow,
  });

  factory NewsCardTokens.of(BuildContext context) {
    final colors = context.appColors;
    final scheme = colors.colorScheme;
    final shadows = AppShadowTokens.of(context);
    return NewsCardTokens._(
      gradientStart: colors.gradients.primaryHeroStart.withValues(alpha: 0.85),
      gradientEnd: colors.gradients.primaryHeroEnd.withValues(alpha: 0.85),
      badgeBackground: scheme.primary,
      badgeText: scheme.onPrimary,
      headline: scheme.onPrimary,
      body: scheme.onPrimary,
      metadata: scheme.onPrimary.withValues(alpha: 0.85),
      ctaBackground: scheme.primary,
      ctaText: scheme.onPrimary,
      iconBackground: scheme.onPrimary.withValues(alpha: 0.2),
      iconColor: scheme.onPrimary.withValues(alpha: 0.7),
      shadow: shadows.level2,
    );
  }

  final Color gradientStart;
  final Color gradientEnd;
  final Color badgeBackground;
  final Color badgeText;
  final Color headline;
  final Color body;
  final Color metadata;
  final Color ctaBackground;
  final Color ctaText;
  final Color iconBackground;
  final Color iconColor;
  final Color shadow;
}

class ModeTabsTokens {
  ModeTabsTokens._({
    required this.container,
    required this.selectedBackground,
    required this.unselectedBackground,
    required this.selectedText,
    required this.unselectedText,
    required this.shadow,
  });

  factory ModeTabsTokens.of(BuildContext context) {
    final colors = context.appColors;
    final shadows = AppShadowTokens.of(context);
    return ModeTabsTokens._(
      container: colors.cardBackground,
      selectedBackground: colors.advanced.primaryFixedDim,
      unselectedBackground: Colors.transparent,
      selectedText: colors.advanced.onPrimaryFixed,
      unselectedText: colors.textSecondary,
      shadow: shadows.level1,
    );
  }

  final Color container;
  final Color selectedBackground;
  final Color unselectedBackground;
  final Color selectedText;
  final Color unselectedText;
  final Color shadow;
}

class RadioGameTabsTokens {
  RadioGameTabsTokens._({
    required this.container,
    required this.selectedBackground,
    required this.unselectedBackground,
    required this.selectedText,
    required this.unselectedText,
    required this.shadow,
  });

  factory RadioGameTabsTokens.of(BuildContext context) {
    final colors = context.appColors;
    final scheme = colors.colorScheme;
    final shadows = AppShadowTokens.of(context);
    final isLight = colors.brightness == Brightness.light;
    
    return RadioGameTabsTokens._(
      container: isLight
          ? colors.surfaces.surfaceContainerHigh
          : colors.surfaces.surfaceContainerHighest,
      selectedBackground: isLight
          ? scheme.onSurface.withValues(alpha: 0.12)
          : scheme.onSurface.withValues(alpha: 0.2),
      unselectedBackground: Colors.transparent,
      selectedText: isLight
          ? scheme.onSurface.withValues(alpha: 0.9)
          : scheme.onSurface.withValues(alpha: 0.95),
      unselectedText: isLight
          ? scheme.onSurface.withValues(alpha: 0.6)
          : scheme.onSurface.withValues(alpha: 0.7),
      shadow: shadows.level1,
    );
  }

  final Color container;
  final Color selectedBackground;
  final Color unselectedBackground;
  final Color selectedText;
  final Color unselectedText;
  final Color shadow;
}

class FeaturedRadioTokens {
  FeaturedRadioTokens._({
    required this.hostFrameBackground,
    required this.tagLiveBackground,
    required this.tagDefaultBackground,
    required this.tagText,
    required this.shadowStrong,
    required this.shadowSoft,
  });

  factory FeaturedRadioTokens.of(BuildContext context) {
    final colors = context.appColors;
    final scheme = colors.colorScheme;
    final shadows = AppShadowTokens.of(context);
    return FeaturedRadioTokens._(
      hostFrameBackground: colors.surfaces.surfaceContainerHighest,
      tagLiveBackground: scheme.error,
      tagDefaultBackground: colors.secondaryAccent,
      tagText: scheme.onPrimary,
      shadowStrong: shadows.level2,
      shadowSoft: shadows.level1,
    );
  }

  final Color hostFrameBackground;
  final Color tagLiveBackground;
  final Color tagDefaultBackground;
  final Color tagText;
  final Color shadowStrong;
  final Color shadowSoft;
}

class RadioBannerTokens {
  RadioBannerTokens._({
    required this.placeholderBackground,
    required this.placeholderText,
    required this.progressColor,
    required this.shadow,
  });

  factory RadioBannerTokens.of(BuildContext context) {
    final colors = context.appColors;
    final shadows = AppShadowTokens.of(context);
    return RadioBannerTokens._(
      placeholderBackground: colors.advanced.tertiaryFixedDim,
      placeholderText: colors.advanced.onTertiaryFixed.withValues(alpha: 0.7),
      progressColor: colors.advanced.onTertiaryFixed.withValues(alpha: 0.8),
      shadow: shadows.level2,
    );
  }

  final Color placeholderBackground;
  final Color placeholderText;
  final Color progressColor;
  final Color shadow;
}

class DialogOverlayTokens {
  DialogOverlayTokens._({
    required this.background,
    required this.barrier,
    required this.surface,
    required this.outline,
  });

  factory DialogOverlayTokens.of(BuildContext context) {
    final colors = context.appColors;
    return DialogOverlayTokens._(
      background: Colors.transparent,
      barrier: colors.gradients.neutralScrim,
      surface: colors.primaryBackground,
      outline: colors.borderSubtle.withValues(alpha: 0.6),
    );
  }

  final Color background;
  final Color barrier;
  final Color surface;
  final Color outline;
}

