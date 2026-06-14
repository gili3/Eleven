import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // الألوان الأساسية بناءً على تحليل الموقع
  static const Color primaryColor = Color(0xFFF59E0B); // Amber/Orange
  static const Color accentColor = Color(0xFFD97706);
  static const Color backgroundColor = Color(0xFFF9FAFB);
  static const Color cardColor = Colors.white;
  static const Color errorColor = Color(0xFFEF4444);
  static const Color textColor = Color(0xFF1F2937);
  static const Color mutedTextColor = Color(0xFF6B7280);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: accentColor,
      error: errorColor,
      surface: cardColor,
    ),
    textTheme: GoogleFonts.cairoTextTheme().copyWith(
      displayLarge: GoogleFonts.cairo(fontSize: 32, fontWeight: FontWeight.bold, color: textColor),
      titleLarge: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
      bodyLarge: GoogleFonts.cairo(fontSize: 16, color: textColor),
      bodyMedium: GoogleFonts.cairo(fontSize: 14, color: textColor),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: textColor),
      titleTextStyle: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
    ),
  );
}
