import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Obsidian Flight Deck Base Palette (StitchMCP Pro Design System)
  static const Color background = Color(0xFF06090E); // Deep Obsidian Void
  static const Color surface = Color(0xFF101419);    // Instrument Panel Base
  static const Color surfaceAlt = Color(0xFF181C21); // Translucent Glass Container
  static const Color surfaceHighlight = Color(0xFF272A30);
  static const Color surfaceBorder = Color(0xFF2B313A);
  static const Color surfaceBorderSoft = Color(0xFF1E232B);

  // Luminous Aviation Instrumentation Accents
  static const Color amber = Color(0xFFFFB020);     // Neon Amber (Warning & Actions)
  static const Color amberDim = Color(0xFF6B4600);
  static const Color cyan = Color(0xFF00F0FF);      // Electric Cyan (Telemetry & Navigation)
  static const Color cyanDim = Color(0xFF004F54);
  static const Color red = Color(0xFFFF3B30);       // Tactical Crimson (Stall & Emergency)
  static const Color redDim = Color(0xFF5C1B17);
  static const Color violet = Color(0xFFA855F7);    // Military Violet (MEL & Investigation)
  static const Color violetDim = Color(0xFF4C1D95);
  static const Color green = Color(0xFF10B981);     // CRT Phosphor Green (Safe & Verified)
  static const Color greenDim = Color(0xFF064E3B);

  // High-Contrast Typography Tones
  static const Color textPrimary = Color(0xFFE0E2EA);
  static const Color textDim = Color(0xFF9EA3B0);
  static const Color textFaint = Color(0xFF5F6573);

  // Glassmorphic Decoration Factory Helper
  static BoxDecoration glassBox({
    Color? borderColor,
    double borderWidth = 1.0,
    Color? backgroundColor,
    double borderRadius = 8.0,
    bool hasGlow = true,
  }) {
    final border = borderColor ?? surfaceBorder;
    return BoxDecoration(
      color: backgroundColor ?? surfaceAlt,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: border, width: borderWidth),
      boxShadow: hasGlow
          ? [
              BoxShadow(
                color: border.withAlpha(35),
                blurRadius: 14,
                spreadRadius: 1,
              ),
            ]
          : null,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: amber,
      colorScheme: const ColorScheme.dark(
        primary: amber,
        secondary: cyan,
        error: red,
        surface: surface,
        onSurface: textPrimary,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.spaceGrotesk(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.8,
        ),
        displayMedium: GoogleFonts.spaceGrotesk(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: amber,
          letterSpacing: 0.5,
        ),
        titleLarge: GoogleFonts.spaceGrotesk(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: 0.2,
        ),
        titleMedium: GoogleFonts.ibmPlexMono(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: 0.2,
        ),
        bodyLarge: GoogleFonts.ibmPlexSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.ibmPlexSans(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textDim,
          height: 1.4,
        ),
        labelLarge: GoogleFonts.ibmPlexMono(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.black,
          letterSpacing: 0.5,
        ),
        labelSmall: GoogleFonts.ibmPlexMono(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: textFaint,
          letterSpacing: 0.5,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: amber,
          letterSpacing: 0.8,
        ),
        iconTheme: const IconThemeData(color: amber),
      ),
      cardTheme: CardThemeData(
        color: surfaceAlt,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: surfaceBorder),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: amber,
          foregroundColor: Colors.black,
          textStyle: GoogleFonts.spaceGrotesk(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: cyan,
          side: const BorderSide(color: cyan),
          textStyle: GoogleFonts.ibmPlexMono(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }
}
