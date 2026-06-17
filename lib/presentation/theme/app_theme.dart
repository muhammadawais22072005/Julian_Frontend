import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ─── COLOR PALETTE SYSTEM CONSTANTS ────────────────────────────────────────
  static const Color primaryNavy = Color(0xFF0F1B2D);
  static const Color secondaryDark = Color(0xFF0D1F3C);
  static const Color highlightTeal = Color(0xFF0E7AAD);
  static const Color highlightBlue = Color(0xFF1A56A0);
  static const Color softBorder = Color(0xFFEEF1F5);
  static const Color stableGreen = Color(0xFF16A34A); // Synced to match the data view cards
  static const Color criticalRed = Color(0xFFE11D48); // Synced to match the data view cards

  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color cardWhite = Colors.white;
  static const Color textDark = Color(0xFF0F1B2D);
  static const Color textGray = Color(0xFF6B7A90);

  static ThemeData get lightTheme {
    // Generate the fundamental base text architecture mappings safely first
    final TextTheme baseTextTheme = GoogleFonts.outfitTextTheme();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: lightBackground,

      // Sanitized ColorScheme explicitly matching updated Material 3 specs
      colorScheme: const ColorScheme.light(
        primary: highlightTeal,
        secondary: highlightBlue,
        surface: cardWhite,
        error: criticalRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textDark,
      ),

      // Fully customized Typography mappings with clean hierarchy configurations
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.outfit(fontSize: 40, fontWeight: FontWeight.bold, color: textDark),
        displayMedium: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: textDark),
        titleLarge: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: textDark),
        titleMedium: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w400 ?? FontWeight.w600, color: textDark),
        bodyLarge: GoogleFonts.inter(fontSize: 15, color: textDark),
        bodyMedium: GoogleFonts.inter(fontSize: 14, color: textGray),
        labelLarge: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600, color: textGray), // Resolved compilation typo (w640 -> w600)
      ),

      // Automated layout injection structures across card targets safely globally
      cardTheme: CardThemeData(
        color: cardWhite,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: softBorder, width: 1),
        ),
      ),

      // Global mapping schema injection variables for lines data segments
      dividerTheme: const DividerThemeData(
        color: softBorder,
        thickness: 1,
        space: 1,
      ),

      // Fully populated M3 Input Form Theme setup matching dashboard fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: softBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: softBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: highlightTeal, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: criticalRed),
        ),
        labelStyle: GoogleFonts.inter(color: textGray, fontSize: 13),
        hintStyle: GoogleFonts.inter(color: textGray.withOpacity(0.5), fontSize: 13),
      ),

      // Clean default global elevated buttons standard styles mapping
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: highlightTeal,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ),

      // Clean default global choice chip component configurations
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        disabledColor: Colors.transparent,
        selectedColor: highlightBlue,
        side: const BorderSide(color: softBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: GoogleFonts.inter(fontSize: 11, color: textGray),
      ),
    );
  }
}