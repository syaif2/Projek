import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  /// Palette from the VORTEKS V2 design reference.
  static const navy = Color(0xFF101C4F);
  static const cyan = Color(0xFF0CA6BC);
  static const canvas = Color(0xFFF1F3F5);
  static const white = Color(0xFFFFFFFF);
  static const paleBlue = Color(0xFFDDECF0);
  static const ink = Color(0xFF1F2937);
  static const muted = Color(0xFF687385);
  static const border = Color(0xFFD7DCE4);
  static const success = Color(0xFF187A59);
  static const warning = Color(0xFF9B5B00);
  static const danger = Color(0xFFB3261E);
}

/// Class options offered on registration and profile editing.
/// Kept identical in both screens so the two forms never disagree.
class ClassOptions {
  const ClassOptions._();

  static const List<String> values = [
    'X IPA 1', 'X IPA 2', 'X IPS 1', 'X IPS 2',
    'XI IPA 1', 'XI IPA 2', 'XI IPS 1', 'XI IPS 2',
    'XII IPA 1', 'XII IPA 2', 'XII IPS 1', 'XII IPS 2',
  ];

  /// Returns [value] unchanged when it is already a known option so an
  /// existing account keeps the class it was registered with.
  static List<String> withCurrent(String value) =>
      values.contains(value) ? values : [...values, value];
}

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.navy,
      primary: AppColors.navy,
      secondary: AppColors.cyan,
      surface: Colors.white,
      error: const Color(0xFFB3261E),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      // Reference screens render on a white body with a light-grey header band.
      scaffoldBackgroundColor: AppColors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.canvas,
        foregroundColor: AppColors.navy,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.navy,
          fontWeight: FontWeight.w900,
          fontSize: 24,
          letterSpacing: 0.4,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        // Reference fields use a notched (floating) label over a navy outline.
        floatingLabelStyle: const TextStyle(
          color: AppColors.navy, fontWeight: FontWeight.w700, fontSize: 16,
        ),
        labelStyle: const TextStyle(color: AppColors.navy, fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.navy),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.navy, width: 1.4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.cyan, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800, decoration: TextDecoration.underline, decorationThickness: 1.4),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navy,
          side: const BorderSide(color: AppColors.navy, width: 1.4),
          minimumSize: const Size(44, 46),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800, decoration: TextDecoration.underline, decorationThickness: 1.4),
        ),
      ),
      // Reference cards are light-grey panels outlined in navy.
      cardTheme: CardThemeData(
        color: AppColors.canvas,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.navy, width: 1.4),
        ),
      ),
      // Reference sliders use a navy active track with a solid navy thumb.
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.navy,
        inactiveTrackColor: Color(0xFFC7CCD3),
        thumbColor: AppColors.navy,
        overlayColor: Color(0x22101C4F),
        trackHeight: 4,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.navy, width: 1.6),
        ),
        titleTextStyle: const TextStyle(
          color: AppColors.navy, fontWeight: FontWeight.w900, fontSize: 21,
        ),
        contentTextStyle: const TextStyle(color: AppColors.ink, fontSize: 15.5, height: 1.45),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: const WidgetStatePropertyAll(AppColors.navy),
        side: const BorderSide(color: AppColors.navy, width: 1.6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.ink, fontSize: 16, height: 1.5),
        bodyMedium: TextStyle(color: AppColors.ink, fontSize: 15, height: 1.5),
      ),
    );
  }
}
