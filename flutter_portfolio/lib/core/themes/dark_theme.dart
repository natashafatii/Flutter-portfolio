import 'package:flutter/material.dart';
import 'text_styles.dart';

class DarkTheme {
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF4DABF7), // Lighter blue for dark mode
      brightness: Brightness.dark,
      primary: const Color(0xFF4DABF7),
      secondary: const Color(0xFF81C784),
      surface: const Color(0xFF121212), // FIXED: background → surface
      surfaceVariant: const Color(0xFF1E1E1E), // Added for surface variations
    ),

    // App Bar
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1E1E1E),
      elevation: 0,
      centerTitle: false,
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    ),

    // Text Theme
    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(color: Colors.white),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(color: Colors.white),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
      headlineSmall: AppTextStyles.headlineSmall.copyWith(color: Colors.white),
      titleLarge: AppTextStyles.titleLarge.copyWith(color: Colors.white),
      titleMedium: AppTextStyles.titleMedium.copyWith(color: Colors.white),
      titleSmall: AppTextStyles.titleSmall.copyWith(color: Colors.white),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: Colors.grey.shade300),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: Colors.grey.shade300),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: Colors.grey.shade400),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: Colors.white),
      labelMedium: AppTextStyles.labelMedium.copyWith(color: Colors.grey.shade400),
      labelSmall: AppTextStyles.labelSmall.copyWith(color: Colors.grey.shade500),
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: const Color(0xFF4DABF7),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: AppTextStyles.labelLarge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    // Cards - FIXED: Use CardThemeData instead of CardTheme
    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
    ),

    // Input Fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2D2D2D),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF4DABF7), width: 2),
      ),
      contentPadding: const EdgeInsets.all(16),
    ),

    // Visual Density
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}