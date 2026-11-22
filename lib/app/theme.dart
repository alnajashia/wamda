import 'package:flutter/material.dart';

class WamdaColors {
  static const teal = Color(0xFF0E7C6B);
  static const amber = Color(0xFFF2A93B);
  static const ink = Color(0xFF14213D);
  static const paper = Color(0xFFF7F8FA);
  static const speed = Color(0xFFE4572E);
  static const flexibility = Color(0xFF7C5CBF);
  static const memory = Color(0xFF0E7C6B);
  static const math = Color(0xFF2563EB);
  static const language = Color(0xFFD6336C);
  static const problem = Color(0xFFB7791F);
  static const focus = Color(0xFF0891B2);
  static const creativity = Color(0xFF65A30D);
}

ThemeData wamdaTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: WamdaColors.teal,
    primary: WamdaColors.teal,
    secondary: WamdaColors.amber,
    surface: Colors.white,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: WamdaColors.paper,
    appBarTheme: const AppBarTheme(
      backgroundColor: WamdaColors.paper,
      foregroundColor: WamdaColors.ink,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: WamdaColors.teal,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: WamdaColors.teal.withValues(alpha: 0.12),
    ),
  );
}
