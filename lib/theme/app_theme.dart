import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    const green = Color(0xFF2E7D32);
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: green),
      scaffoldBackgroundColor: const Color(0xFFF7FAF7),
      useMaterial3: true,
      cardTheme: const CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
    );
  }
}
