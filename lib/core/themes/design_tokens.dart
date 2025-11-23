import 'package:flutter/material.dart';

class DesignTokens {
  DesignTokens._();

  static const double spacingXs = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 12.0;
  static const double spacingL = 16.0;
  static const double spacingXl = 24.0;
  static const double spacingXxl = 32.0;

  static const double cornerRadiusCard = 16.0;
  static const double cornerRadiusButton = 20.0;
  static const double cornerRadiusPill = 24.0;
  static const double cornerRadiusAvatar = 999.0;

  static const double elevationCard = 4.0;
  static const double elevationCardHover = 6.0;
  static const double elevationCardActive = 8.0;
  static const double elevationNavBar = 8.0;
  static const double elevationNavBarHover = 12.0;
  static const double elevationFab = 12.0;
  static const double elevationFabHover = 16.0;

  static const double fontSizeH1 = 22.0;
  static const double fontSizeH2 = 16.0;
  static const double fontSizeBody = 14.0;
  static const double fontSizeCaption = 12.0;
  static const double fontSizeNumbers = 20.0;

  static const FontWeight fontWeightH1 = FontWeight.w600;
  static const FontWeight fontWeightH2 = FontWeight.w600;
  static const FontWeight fontWeightBody = FontWeight.w400;
  static const FontWeight fontWeightCaption = FontWeight.w400;
  static const FontWeight fontWeightNumbers = FontWeight.w600;

  static const Color colorPrimaryBackground = Color(0xFFF5F7FA);
  static const Color colorHeaderGradientStart = Color(0xFF00B4DB);
  static const Color colorHeaderGradientEnd = Color(0xFF0083B0);
  static const Color colorCard = Color(0xFFFFFFFF);
  static const Color colorPrimaryAccent = Color(0xFFFF9F1C);
  static const Color colorSecondaryAccent = Color(0xFF00C2FF);
  static const Color colorTextPrimary = Color(0xFF1F2933);
  static const Color colorTextSecondary = Color(0xFF6B7280);
  static const Color colorBorderSubtle = Color(0xFFE5E7EB);

  static const Color colorNavBarBackground = Color(0xFFE8D5FF);
  static const Color colorNavBarIconSelected = Color(0xFF6B46C1);
  static const Color colorNavBarIconUnselected = Color(0xFF9F7AEA);

  static const Duration animationDurationShort = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationLong = Duration(milliseconds: 500);

  static const Curve animationCurveDefault = Curves.easeInOut;
  static const Curve animationCurveSpring = Curves.easeOutCubic;
  static const Curve animationCurveBounce = Curves.easeOutBack;
}

extension SpacingExtension on num {
  double get xs => this * DesignTokens.spacingXs;
  double get s => this * DesignTokens.spacingS;
  double get m => this * DesignTokens.spacingM;
  double get l => this * DesignTokens.spacingL;
  double get xl => this * DesignTokens.spacingXl;
  double get xxl => this * DesignTokens.spacingXxl;
}

