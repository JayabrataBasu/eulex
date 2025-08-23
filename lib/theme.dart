import 'package:flutter/material.dart';

enum CalculatorThemeMode { dark, light, vibrant }

class CalculatorTheme {
  final ThemeData themeData;
  final Color displayBackground;
  final Color buttonBackground;
  final Color operatorButtonBackground;
  final Color buttonTextColor;
  final Color operatorTextColor;
  final Color historyBackground;

  const CalculatorTheme({
    required this.themeData,
    required this.displayBackground,
    required this.buttonBackground,
    required this.operatorButtonBackground,
    required this.buttonTextColor,
    required this.operatorTextColor,
    required this.historyBackground,
  });
}

final calculatorThemes = {
  CalculatorThemeMode.dark: CalculatorTheme(
    themeData: ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0xFF6C61F6),
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Color(0xFF181A20),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF22252D),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    ),
    displayBackground: const Color(0xFF292D36),
    buttonBackground: const Color(0xFF292D36),
    operatorButtonBackground: const Color(0xFF6C61F6),
    buttonTextColor: Colors.white70,
    operatorTextColor: Colors.white,
    historyBackground: const Color(0xFF181A20),
  ),
  CalculatorThemeMode.light: CalculatorTheme(
    themeData: ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0xFF4CAF50),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFEDEDED),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
    ),
    displayBackground: const Color(0xFFF5F5F5),
    buttonBackground: const Color(0xFFE0E0E0),
    operatorButtonBackground: const Color(0xFF4CAF50),
    buttonTextColor: Colors.black87,
    operatorTextColor: Colors.white,
    historyBackground: const Color(0xFFF0F0F0),
  ),
  CalculatorThemeMode.vibrant: CalculatorTheme(
    themeData: ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0xFF1976D2),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFFDF6F0),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    ),
    displayBackground: const Color(0xFFB3E5FC),
    buttonBackground: const Color(0xFFFFF3E0),
    operatorButtonBackground: const Color(0xFFFF9800),
    buttonTextColor: Color(0xFF263238),
    operatorTextColor: Colors.white,
    historyBackground: const Color(0xFFFFF8E1),
  ),
};
