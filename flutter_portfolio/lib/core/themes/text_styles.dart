import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // =============== DISPLAY STYLES (Hero/Logo Text) ===============
  static final displayLarge = GoogleFonts.montserrat(
    fontSize: 72,
    fontWeight: FontWeight.w900,
    height: 1.0,
    letterSpacing: -1.5,
  );

  static final displayMedium = GoogleFonts.montserrat(
    fontSize: 57,
    fontWeight: FontWeight.w700,
    height: 1.12,
    letterSpacing: -0.25,
  );

  static final displaySmall = GoogleFonts.montserrat(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.16,
    letterSpacing: 0,
  );

  // =============== HEADLINE STYLES (Page/Section Titles) ===============
  static final headlineLarge = GoogleFonts.montserrat(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0,
  );

  static final headlineMedium = GoogleFonts.montserrat(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0,
  );

  static final headlineSmall = GoogleFonts.montserrat(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0,
  );

  // =============== TITLE STYLES (Card/Widget Titles) ===============
  static final titleLarge = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.27,
    letterSpacing: 0,
  );

  static final titleMedium = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.15,
  );

  static final titleSmall = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.1,
  );

  // =============== BODY STYLES (Paragraph Text) ===============
  static final bodyLarge = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.56,
    letterSpacing: 0.15,
  );

  static final bodyMedium = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.25,
  );

  static final bodySmall = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0.4,
  );

  // =============== LABEL STYLES (UI Controls) ===============
  static final labelLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.1,
  );

  static final labelMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.5,
  );

  static final labelSmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.5,
  );

  // =============== SPECIAL STYLES ===============
  static final buttonLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.25,
    height: 1.5,
  );

  static final buttonMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.25,
    height: 1.43,
  );

  static final buttonSmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.25,
    height: 1.33,
  );

  static final caption = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.45,
  );

  static final overline = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.5,
    height: 1.6,
  );

  // =============== CODE/TECHNICAL TEXT ===============
  static final codeLarge = GoogleFonts.robotoMono(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.5,
  );

  static final codeMedium = GoogleFonts.robotoMono(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0.25,
  );

  static final codeSmall = GoogleFonts.robotoMono(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0,
  );

  // =============== HELPER METHODS ===============
  /// Get text style with custom color
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Get text style with custom opacity
  static TextStyle withOpacity(TextStyle style, double opacity) {
    return style.copyWith(color: style.color?.withOpacity(opacity));
  }

  /// Get gradient text style (for shader masks)
  static TextStyle getGradientStyle({
    required TextStyle baseStyle,
    required List<Color> gradientColors,
  }) {
    return baseStyle.copyWith(
      foreground: Paint()
        ..shader = LinearGradient(
          colors: gradientColors,
        ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
    );
  }
}