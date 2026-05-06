import 'package:flutter/material.dart';

class AppDimensions {
  // المسافات (Padding & Margin)
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // أحجام الخطوط
  static const double textXs = 12.0;
  static const double textSm = 14.0;
  static const double textMd = 16.0;
  static const double textLg = 18.0;
  static const double textXl = 20.0;
  static const double textXxl = 24.0;
  static const double textDisplay = 32.0;

  // ارتفاعات العناصر
  static const double buttonHeight = 48.0;
  static const double appBarHeight = 56.0;
  static const double cardHeight = 200.0;
  static const double sliderHeight = 220.0;

  // أنصاف أقطار (Border Radius)
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusCircle = 999.0;

  // الظلال (Shadows)
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}