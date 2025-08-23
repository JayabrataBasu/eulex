import 'package:flutter/material.dart';

enum CalculatorThemeMode {
  dark,
  light,
  vibrant,
  neoMint,
  cyberpunk,
  solarSunset,
  royalElegance,
  materialYou,
  matrixHacker,
  pastelCandy,
}

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
  // 1. Neo-Mint Minimal
  CalculatorThemeMode.neoMint: CalculatorTheme(
    themeData: ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0xFF00C49A),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Color(0xFFE8F9F7),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF00C49A),
        foregroundColor: Color(0xFF222831),
        elevation: 0,
      ),
    ),
    displayBackground: const Color(0xFFF7F7F7),
    buttonBackground: const Color(0xFFF7F7F7),
    operatorButtonBackground: const Color(0xFF00C49A),
    buttonTextColor: Color(0xFF222831),
    operatorTextColor: Colors.white,
    historyBackground: const Color(0xFFE8F9F7),
  ),
  // 2. Cyberpunk Glow
  CalculatorThemeMode.cyberpunk: CalculatorTheme(
    themeData: ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0xFFFF007F),
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Color(0xFF1A1A2E),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0D0D0D),
        foregroundColor: Color(0xFF00FFE0),
        elevation: 0,
      ),
    ),
    displayBackground: const Color(0xFF0D0D0D),
    buttonBackground: const Color(0xFF1A1A2E),
    operatorButtonBackground: const Color(0xFFFF007F),
    buttonTextColor: Color(0xFF00FFE0),
    operatorTextColor: Color(0xFF00FFE0),
    historyBackground: const Color(0xFF1A1A2E),
  ),
  // 3. Solar Sunset
  CalculatorThemeMode.solarSunset: CalculatorTheme(
    themeData: ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0xFFFF6F61),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Color(0xFFF9F9F9),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFFD166),
        foregroundColor: Color(0xFF06D6A0),
        elevation: 0,
      ),
    ),
    displayBackground: const Color(0xFFFFD166),
    buttonBackground: const Color(0xFFFFF3E0),
    operatorButtonBackground: const Color(0xFFFF6F61),
    buttonTextColor: Color(0xFF06D6A0),
    operatorTextColor: Colors.white,
    historyBackground: const Color(0xFFF9F9F9),
  ),
  // 4. Royal Elegance
  CalculatorThemeMode.royalElegance: CalculatorTheme(
    themeData: ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0xFF2E294E),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Color(0xFFF4F1DE),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2E294E),
        foregroundColor: Color(0xFFFF9F1C),
        elevation: 0,
      ),
    ),
    displayBackground: const Color(0xFFF4F1DE),
    buttonBackground: const Color(0xFFFF9F1C),
    operatorButtonBackground: const Color(0xFFE71D36),
    buttonTextColor: Color(0xFF2E294E),
    operatorTextColor: Colors.white,
    historyBackground: const Color(0xFFF4F1DE),
  ),
  // 5. Material You Inspired
  CalculatorThemeMode.materialYou: CalculatorTheme(
    themeData: ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0xFF6750A4),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Color(0xFFF5F0FF),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF6750A4),
        foregroundColor: Color(0xFFD0BCFF),
        elevation: 0,
      ),
    ),
    displayBackground: const Color(0xFFD0BCFF),
    buttonBackground: const Color(0xFFF5F0FF),
    operatorButtonBackground: const Color(0xFF7D5260),
    buttonTextColor: Color(0xFF6750A4),
    operatorTextColor: Colors.white,
    historyBackground: const Color(0xFFF5F0FF),
  ),
  // 6. Matrix Hacker
  CalculatorThemeMode.matrixHacker: CalculatorTheme(
    themeData: ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0xFF00FF41),
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Color(0xFF00FF41),
        elevation: 0,
      ),
    ),
    displayBackground: const Color(0xFF1E1E1E),
    buttonBackground: const Color(0xFF121212),
    operatorButtonBackground: const Color(0xFF00FF41),
    buttonTextColor: Color(0xFF03DAC6),
    operatorTextColor: Color(0xFF121212),
    historyBackground: const Color(0xFF121212),
  ),
  // 7. Pastel Candy
  CalculatorThemeMode.pastelCandy: CalculatorTheme(
    themeData: ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0xFFFDFFB6),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Color(0xFFCAFFBF),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFFADAD),
        foregroundColor: Color(0xFFFDFFB6),
        elevation: 0,
      ),
    ),
    displayBackground: const Color(0xFFFFD6A5),
    buttonBackground: const Color(0xFFFDFFB6),
    operatorButtonBackground: const Color(0xFFFFADAD),
    buttonTextColor: Color(0xFF222831),
    operatorTextColor: Color(0xFF222831),
    historyBackground: const Color(0xFFCAFFBF),
  ),
};
