import 'package:flutter/material.dart';

class M3XMenuStyle {
  static const double menuRadius = 16.0; // More rounded than baseline
  static const double gapSize = 8.0;
  
  static MenuStyle get menuStyle => MenuStyle(
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(menuRadius),
      ),
    ),
    padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(vertical: 8.0),
    ),
    elevation: WidgetStateProperty.all(2.0),
  );

  static ButtonStyle get itemStyle => ButtonStyle(
    padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    ),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Inner item radius
      ),
    ),
  );
}
