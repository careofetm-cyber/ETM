import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:etm_core/etm_core.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => _buildTheme(AppColors.primary);

  static ThemeData fromCompanyBranding(Color primaryColor) {
    return _buildTheme(primaryColor);
  }

  static ThemeData _buildTheme(Color primaryColor) {
    final primaryLight = Color.lerp(primaryColor, Colors.white, 0.3)!;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        onPrimary: AppColors.textInverse,
        primaryContainer: primaryLight,
        secondary: AppColors.secondary,
        onSecondary: AppColors.textInverse,
        error: AppColors.error,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.interTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: AppColors.textInverse,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppDarkColors.primary,
        onPrimary: AppColors.textInverse,
        primaryContainer: AppDarkColors.primaryDark,
        secondary: AppDarkColors.secondary,
        onSecondary: AppColors.textInverse,
        error: AppDarkColors.error,
        surface: AppDarkColors.surface,
        onSurface: AppDarkColors.textPrimary,
      ),
      scaffoldBackgroundColor: AppDarkColors.background,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    );
  }
}
