# Design Tokens Guide

This document outlines the design token system used in the app to ensure consistent UI/UX and Material Design 3 Expressive compliance.

## Overview

Design tokens are centralized values that define the visual design language of the app. They ensure consistency across all features and make it easy to maintain and update the design system.

## Token Categories

### Spacing Tokens

Located in `lib/core/themes/design_tokens.dart`:

- `DesignTokens.spacingXs` = 4.0
- `DesignTokens.spacingS` = 8.0
- `DesignTokens.spacingM` = 12.0
- `DesignTokens.spacingL` = 16.0
- `DesignTokens.spacingXl` = 24.0
- `DesignTokens.spacingXxl` = 32.0

**Usage:**
```dart
// ✅ Correct
padding: EdgeInsets.all(DesignTokens.spacingL)
SizedBox(height: DesignTokens.spacingXl)

// ❌ Wrong
padding: EdgeInsets.all(16.0)
SizedBox(height: 24)
```

### Dimension Tokens

Standard sizes for common UI elements:

- `DimensionTokens.iconSizeSmall` = 16.0
- `DimensionTokens.iconSizeMedium` = 20.0
- `DimensionTokens.iconSizeLarge` = 24.0
- `DimensionTokens.avatarSizeSmall` = 40.0
- `DimensionTokens.avatarSizeMedium` = 48.0
- `DimensionTokens.avatarSizeLarge` = 56.0

### Typography Tokens

Material Design 3 Expressive typography scale:

- Display: `fontSizeDisplayLarge/Medium/Small`
- Headline: `fontSizeHeadlineLarge/Medium/Small`
- Title: `fontSizeTitleLarge/Medium/Small`
- Body: `fontSizeBodyLarge/Medium/Small`
- Label: `fontSizeLabelLarge/Medium/Small`

**Usage:**
```dart
// ✅ Correct
TextStyle(
  fontSize: DesignTokens.fontSizeTitleLarge,
  fontWeight: DesignTokens.fontWeightTitleLarge,
  letterSpacing: DesignTokens.letterSpacingTitleLarge,
)

// ❌ Wrong
TextStyle(fontSize: 22, fontWeight: FontWeight.w400)
```

### Color Tokens

#### Semantic Colors

Access via `context.appColors`:

- `colors.textPrimary` - Primary text color
- `colors.textSecondary` - Secondary text color
- `colors.cardBackground` - Card background
- `colors.primaryBackground` - Main background
- `colors.borderSubtle` - Subtle borders

#### Component Tokens

Feature-specific color tokens:

- `HomeHeaderTokens.of(context)`
- `ShoutboxTokens.of(context)`
- `FeaturedRadioTokens.of(context)`
- `ShareCardTokens.of(context)`

**Usage:**
```dart
// ✅ Correct
final colors = context.appColors;
final tokens = ShoutboxTokens.of(context);
color: tokens.composerBackground

// ❌ Wrong
color: Colors.white
color: Theme.of(context).colorScheme.surface
```

### Animation Tokens

Standard animation durations and curves:

- `DesignTokens.animationDurationShort` = 200ms
- `DesignTokens.animationDurationMedium` = 300ms
- `DesignTokens.animationDurationLong` = 500ms
- `DesignTokens.animationCurveDefault` = Curves.easeInOut
- `DesignTokens.animationCurveSpring` = Curves.easeOutCubic

**Usage:**
```dart
// ✅ Correct
duration: DesignTokens.animationDurationMedium,
curve: DesignTokens.animationCurveDefault,

// ❌ Wrong
duration: Duration(milliseconds: 300),
curve: Curves.easeOut,
```

## Best Practices

1. **Always use tokens** - Never hard-code spacing, colors, or typography values
2. **Use semantic tokens** - Prefer semantic color tokens over direct color access
3. **Component tokens for features** - Use component-specific tokens when available
4. **Consistent spacing** - Use spacing tokens for all padding and margins
5. **Typography scale** - Always use the M3 expressive typography scale

## Linter Rules

The project includes linter rules to enforce design token usage:

- Prevents hard-coded `EdgeInsets` values
- Prevents hard-coded `SizedBox` dimensions
- Encourages const constructors
- Enforces proper resource disposal

## CI/CD Checks

Automated checks verify:
- No hard-coded spacing values
- No hard-coded dimensions
- Translation completeness
- Resource disposal patterns

## Migration Guide

When updating existing code:

1. Replace `EdgeInsets.all(16.0)` → `EdgeInsets.all(DesignTokens.spacingL)`
2. Replace `SizedBox(height: 24)` → `SizedBox(height: DesignTokens.spacingXl)`
3. Replace `Colors.white/black` → Semantic tokens or component tokens
4. Replace hard-coded font sizes → Typography tokens
5. Replace animation durations → Animation tokens

