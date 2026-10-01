import 'package:flutter/material.dart';
import 'text_styles.dart';

class LightTheme {
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0066CC), // Professional blue
      brightness: Brightness.light,
      primary: const Color(0xFF0066CC),
      secondary: const Color(0xFF66BB6A),
      surface: const Color(0xFFF8F9FA), // FIXED: background → surface
    ),

    // App Bar
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    ),

    // Text Theme
    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(color: Colors.black),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(color: Colors.black),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(color: Colors.black),
      headlineSmall: AppTextStyles.headlineSmall.copyWith(color: Colors.black),
      titleLarge: AppTextStyles.titleLarge.copyWith(color: Colors.black87),
      titleMedium: AppTextStyles.titleMedium.copyWith(color: Colors.black87),
      titleSmall: AppTextStyles.titleSmall.copyWith(color: Colors.black87),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: Colors.black87),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: Colors.black87),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: Colors.black54),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: Colors.black87),
      labelMedium: AppTextStyles.labelMedium.copyWith(color: Colors.black54),
      labelSmall: AppTextStyles.labelSmall.copyWith(color: Colors.black38),
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF0066CC),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: AppTextStyles.labelLarge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    // Cards - FIXED: Use CardThemeData instead of CardTheme
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
    ),

    // Input Fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF0066CC), width: 2),
      ),
      contentPadding: const EdgeInsets.all(16),
    ),

    // Visual Density
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}