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

enum ButtonType { number, operator, function, memory, utility }

class CalculatorTheme {
  final ThemeData themeData;
  final Color numberColor;
  final Color operatorColor;
  final Color functionColor;
  final Color memoryColor;
  final Color utilityColor;
  final Color numberTextColor;
  final Color operatorTextColor;
  final Color functionTextColor;
  final Color memoryTextColor;
  final Color utilityTextColor;
  final Color displayBackground;
  final Color historyBackground;

  const CalculatorTheme({
    required this.themeData,
    required this.numberColor,
    required this.operatorColor,
    required this.functionColor,
    required this.memoryColor,
    required this.utilityColor,
    required this.numberTextColor,
    required this.operatorTextColor,
    required this.functionTextColor,
    required this.memoryTextColor,
    required this.utilityTextColor,
    required this.displayBackground,
    required this.historyBackground,
  });

  // Add these getters for compatibility with main.dart and other UI code:
  Color get numberButtonColor => numberColor;
  Color get operatorButtonColor => operatorColor;
  Color get functionButtonColor => functionColor;
  Color get memoryButtonColor => memoryColor;
  Color get utilityButtonColor => utilityColor;
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
    numberColor: Color(0xFF292D36),
    operatorColor: Color(0xFF6C61F6),
    functionColor: Color(0xFF00C49A),
    memoryColor: Color(0xFFFFD166),
    utilityColor: Color(0xFF22252D),
    numberTextColor: Colors.white,
    operatorTextColor: Colors.white,
    functionTextColor: Colors.white,
    memoryTextColor: Colors.black,
    utilityTextColor: Colors.white,
    displayBackground: Color(0xFF292D36),
    historyBackground: Color(0xFF181A20),
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
    numberColor: Colors.white,
    operatorColor: Color(0xFF4CAF50),
    functionColor: Color(0xFF1976D2),
    memoryColor: Color(0xFFFFD166),
    utilityColor: Color(0xFFE0E0E0),
    numberTextColor: Colors.black,
    operatorTextColor: Colors.white,
    functionTextColor: Colors.white,
    memoryTextColor: Colors.black,
    utilityTextColor: Colors.black,
    displayBackground: Color(0xFFF5F5F5),
    historyBackground: Color(0xFFF0F0F0),
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
    numberColor: Colors.white,
    operatorColor: Color(0xFF4CAF50),
    functionColor: Color(0xFF1976D2),
    memoryColor: Color(0xFFFFD166),
    utilityColor: Color(0xFFE0E0E0),
    numberTextColor: Colors.black,
    operatorTextColor: Colors.white,
    functionTextColor: Colors.white,
    memoryTextColor: Colors.black,
    utilityTextColor: Colors.black,
    displayBackground: const Color(0xFFB3E5FC),
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
    numberColor: Colors.white,
    operatorColor: Color(0xFF00C49A),
    functionColor: Color(0xFF1976D2),
    memoryColor: Color(0xFFFFD166),
    utilityColor: Color(0xFFE0E0E0),
    numberTextColor: Colors.black,
    operatorTextColor: Colors.white,
    functionTextColor: Colors.white,
    memoryTextColor: Colors.black,
    utilityTextColor: Colors.black,
    displayBackground: const Color(0xFFF7F7F7),
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
    numberColor: Color(0xFF0D0D0D),
    operatorColor: Color(0xFFFF007F),
    functionColor: Color(0xFF00C49A),
    memoryColor: Color(0xFFFFD166),
    utilityColor: Color(0xFF1A1A2E),
    numberTextColor: Colors.white,
    operatorTextColor: Color(0xFF00FFE0),
    functionTextColor: Color(0xFF00FFE0),
    memoryTextColor: Colors.black,
    utilityTextColor: Colors.white,
    displayBackground: const Color(0xFF0D0D0D),
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
    numberColor: Colors.white,
    operatorColor: Color(0xFFFF6F61),
    functionColor: Color(0xFF1976D2),
    memoryColor: Color(0xFFFFD166),
    utilityColor: Color(0xFFE0E0E0),
    numberTextColor: Colors.black,
    operatorTextColor: Colors.white,
    functionTextColor: Colors.white,
    memoryTextColor: Colors.black,
    utilityTextColor: Colors.black,
    displayBackground: const Color(0xFFFFD166),
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
    numberColor: Colors.white,
    operatorColor: Color(0xFFE71D36),
    functionColor: Color(0xFF1976D2),
    memoryColor: Color(0xFFFFD166),
    utilityColor: Color(0xFFF4F1DE),
    numberTextColor: Colors.black,
    operatorTextColor: Colors.white,
    functionTextColor: Colors.white,
    memoryTextColor: Colors.black,
    utilityTextColor: Colors.black,
    displayBackground: const Color(0xFFF4F1DE),
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
    numberColor: Colors.white,
    operatorColor: Color(0xFF7D5260),
    functionColor: Color(0xFF1976D2),
    memoryColor: Color(0xFFFFD166),
    utilityColor: Color(0xFFF5F0FF),
    numberTextColor: Colors.black,
    operatorTextColor: Colors.white,
    functionTextColor: Colors.white,
    memoryTextColor: Colors.black,
    utilityTextColor: Colors.black,
    displayBackground: const Color(0xFFD0BCFF),
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
    numberColor: Color(0xFF1E1E1E),
    operatorColor: Color(0xFF00FF41),
    functionColor: Color(0xFF1976D2),
    memoryColor: Color(0xFFFFD166),
    utilityColor: Color(0xFF121212),
    numberTextColor: Colors.white,
    operatorTextColor: Color(0xFF00FF41),
    functionTextColor: Color(0xFF121212),
    memoryTextColor: Color(0xFF03DAC6),
    utilityTextColor: Colors.white,
    displayBackground: const Color(0xFF1E1E1E),
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
    numberColor: Colors.white,
    operatorColor: Color(0xFFFFADAD),
    functionColor: Color(0xFF1976D2),
    memoryColor: Color(0xFFFFD166),
    utilityColor: Color(0xFFFDFFB6),
    numberTextColor: Color(0xFF222831),
    operatorTextColor: Color(0xFF222831),
    functionTextColor: Color(0xFF222831),
    memoryTextColor: Color(0xFF222831),
    utilityTextColor: Color(0xFF222831),
    displayBackground: const Color(0xFFFFD6A5),
    historyBackground: const Color(0xFFCAFFBF),
  ),
};
