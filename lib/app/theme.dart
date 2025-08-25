// lib/app/theme.dart

import 'package:flutter/material.dart';

class CalculatorTheme {
  final String name;
  final Color background;
  final Color displayBackground;
  final Color functionButton;
  final Color operatorButton;
  final Color controlButton;
  final Color shiftButton;
  final Color alphaButton;
  final Color shiftLabelText;
  final Color alphaLabelText;
  final Brightness brightness;
  const CalculatorTheme({
    required this.name,
    required this.background,
    required this.displayBackground,
    required this.functionButton,
    required this.operatorButton,
    required this.controlButton,
    required this.shiftButton,
    required this.alphaButton,
    required this.shiftLabelText,
    required this.alphaLabelText,
    required this.brightness,
  });
}

class CalculatorThemes {
  static const classicLight = CalculatorTheme(
    name: 'Classic Light',
    background: Color(0xFFF0F0F0),
    displayBackground: Color(0xFFE3F2FD),
    functionButton: Color(0xFFE0E0E0),
    operatorButton: Color(0xFFBDBDBD),
    controlButton: Color(0xFFD32F2F),
    shiftButton: Color(0xFFF9A825),
    alphaButton: Color(0xFFE91E63),
    shiftLabelText: Color(0xFFD39823),
    alphaLabelText: Color(0xFFC0392B),
    brightness: Brightness.light,
  );
  static const carbonDark = CalculatorTheme(
    name: 'Carbon Dark',
    background: Color(0xFF121212),
    displayBackground: Color(0xFF1E1E1E),
    functionButton: Color(0xFF2A2A2A),
    operatorButton: Color(0xFF303841),
    controlButton: Color(0xFFB71C1C),
    shiftButton: Color(0xFF00ACC1),
    alphaButton: Color(0xFFFFB300),
    shiftLabelText: Color(0xFF26C6DA),
    alphaLabelText: Color(0xFFFFD54F),
    brightness: Brightness.dark,
  );
  static const oceanBlue = CalculatorTheme(
    name: 'Ocean Blue',
    background: Color(0xFF0D1B2A),
    displayBackground: Color(0xFF1B263B),
    functionButton: Color(0xFF415A77),
    operatorButton: Color(0xFF778DA9),
    controlButton: Color(0xFFB23A48),
    shiftButton: Color(0xFF1E6091),
    alphaButton: Color(0xFF184E77),
    shiftLabelText: Color(0xFF89C2D9),
    alphaLabelText: Color(0xFFFFD60A),
    brightness: Brightness.dark,
  );
  static const sunsetOrange = CalculatorTheme(
    name: 'Sunset Orange',
    background: Color(0xFF2F1B12),
    displayBackground: Color(0xFF493123),
    functionButton: Color(0xFF8C4A2F),
    operatorButton: Color(0xFFAD5D3D),
    controlButton: Color(0xFFD1495B),
    shiftButton: Color(0xFFF7B267),
    alphaButton: Color(0xFFF4845F),
    shiftLabelText: Color(0xFFFFC857),
    alphaLabelText: Color(0xFFFFA552),
    brightness: Brightness.dark,
  );

  static const all = [classicLight, carbonDark, oceanBlue, sunsetOrange];
}

// Backwards compatibility aliases for existing code referencing AppColors
class AppColors {
  static Color get background => CalculatorThemes.all.first.background;
  static Color get displayBackground =>
      CalculatorThemes.all.first.displayBackground;
  static Color get functionButton => CalculatorThemes.all.first.functionButton;
  static Color get operatorButton => CalculatorThemes.all.first.operatorButton;
  static Color get controlButton => CalculatorThemes.all.first.controlButton;
  static Color get shiftButton => CalculatorThemes.all.first.shiftButton;
  static Color get alphaButton => CalculatorThemes.all.first.alphaButton;
  static Color get shiftLabelText => CalculatorThemes.all.first.shiftLabelText;
  static Color get alphaLabelText => CalculatorThemes.all.first.alphaLabelText;
}
