import 'package:flutter/material.dart';

class AppTheme {
  static const background = Color(0xFF080808);
  static const surface = Color(0xFF111111);
  static const surfaceAlt = Color(0xFF171717);
  static const primary = Color(0xFFFF8A3D);
  static const text = Color(0xFFF4F1EC);
  static const muted = Color(0xFFB7B0A8);
  static const border = Color(0xFF2B2926);

  const AppTheme._();

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: primary,
        surface: surface,
        onSurface: text,
      ),
      scaffoldBackgroundColor: background,
      cardColor: surfaceAlt,
      dividerColor: border,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: const Color(0xFF120B06),
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: text,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          side: const BorderSide(color: border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: muted,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      textTheme: const TextTheme(
        displayMedium: TextStyle(
          color: text,
          fontSize: 48,
          fontWeight: FontWeight.w700,
          height: 1.08,
        ),
        headlineMedium: TextStyle(
          color: text,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ),
        titleMedium: TextStyle(
          color: text,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.35,
        ),
        bodyLarge: TextStyle(color: text, fontSize: 16, height: 1.72),
        bodyMedium: TextStyle(color: muted, fontSize: 14, height: 1.65),
      ),
    );
  }
}
