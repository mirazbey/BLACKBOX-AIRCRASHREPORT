import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFF0A0D12);
  static const Color surface = Color(0xFF12161D);
  static const Color surfaceAlt = Color(0xFF161B23);
  static const Color surfaceBorder = Color(0xFF262E38);
  static const Color surfaceBorderSoft = Color(0xFF1B222B);

  // Tactical Aviation Accents
  static const Color amber = Color(0xFFFFB020);
  static const Color amberDim = Color(0xFF7A5A1E);
  static const Color cyan = Color(0xFF46D9C9);
  static const Color cyanDim = Color(0xFF1F4D48);
  static const Color red = Color(0xFFFF6161);
  static const Color redDim = Color(0xFF5C2323);
  static const Color violet = Color(0xFF9B8CFF);
  static const Color violetDim = Color(0xFF332C57);
  static const Color green = Color(0xFF00FF66);

  // Text
  static const Color textPrimary = Color(0xFFE7ECF2);
  static const Color textDim = Color(0xFF93A0B0);
  static const Color textFaint = Color(0xFF57616D);

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
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.spaceGrotesk(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.spaceGrotesk(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: amber,
          letterSpacing: 0.5,
        ),
        titleMedium: GoogleFonts.ibmPlexMono(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: textPrimary,
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
          color: background,
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
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: amber,
          letterSpacing: 0.5,
        ),
        iconTheme: const IconThemeData(color: amber),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: surfaceBorder, width: 1),
        ),
      ),
    );
  }
}
