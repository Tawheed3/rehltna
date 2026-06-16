import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static TextTheme _cairoTextTheme(TextTheme base) =>
      GoogleFonts.cairoTextTheme(base);

  // الثيم الفاتح
  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      cardColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: Colors.white,
        background: Color(0xFFF8FAFC),
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFF0F172A),
        onBackground: Color(0xFF0F172A),
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF0F172A),
      ),
    );

    return base.copyWith(
      textTheme: _cairoTextTheme(base.textTheme).copyWith(
        bodyLarge: GoogleFonts.cairo(color: AppColors.textPrimary, fontSize: 16),
        bodyMedium: GoogleFonts.cairo(color: AppColors.textSecondary, fontSize: 14),
        bodySmall: GoogleFonts.cairo(color: AppColors.textLight, fontSize: 12),
        titleLarge: GoogleFonts.cairo(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w700),
        titleMedium: GoogleFonts.cairo(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
        titleSmall: GoogleFonts.cairo(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600),
        labelLarge: GoogleFonts.cairo(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }

  // الثيم الداكن
  static ThemeData get darkTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF1E1E1E),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: Color(0xFF1E1E1E),
        background: Color(0xFF121212),
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
    );

    return base.copyWith(
      textTheme: _cairoTextTheme(base.textTheme).copyWith(
        bodyLarge: GoogleFonts.cairo(color: Colors.white, fontSize: 16),
        bodyMedium: GoogleFonts.cairo(color: Colors.white70, fontSize: 14),
        bodySmall: GoogleFonts.cairo(color: Colors.white54, fontSize: 12),
        titleLarge: GoogleFonts.cairo(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
        titleMedium: GoogleFonts.cairo(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        titleSmall: GoogleFonts.cairo(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
        labelLarge: GoogleFonts.cairo(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }
}
