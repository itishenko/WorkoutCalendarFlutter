import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFFF6F2EA);
  static const Color shell = Color(0xFFFBF9F5);
  static const Color card = Colors.white;
  static const Color outline = Color(0xFFE5DDD3);
  static const Color accent = Color(0xFF146C94);
  static const Color accentDeep = Color(0xFF0D4D6B);
  static const Color success = Color(0xFF3A7D44);
  static const Color warning = Color(0xFFC96B3C);

  static const LinearGradient pageGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      Color(0xFFF9F2E6),
      Color(0xFFEAF4F7),
      Color(0xFFF6F2EA),
    ],
  );

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: Brightness.light,
    ).copyWith(
      primary: accent,
      secondary: warning,
      surface: card,
      outlineVariant: outline,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      dividerTheme: const DividerThemeData(
        space: 1,
        thickness: 1,
        color: outline,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: accent.withValues(alpha: 0.10),
        selectedColor: accent.withValues(alpha: 0.18),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
