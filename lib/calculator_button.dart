import 'package:flutter/material.dart';
import 'theme.dart';

class CalculatorButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final ButtonType type;
  final CalculatorTheme theme;

  const CalculatorButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.type,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    switch (type) {
      case ButtonType.number:
        bg = theme.numberColor;
        fg = theme.numberTextColor;
        break;
      case ButtonType.operator:
        bg = theme.operatorColor;
        fg = theme.operatorTextColor;
        break;
      case ButtonType.function:
        bg = theme.functionColor;
        fg = theme.functionTextColor;
        break;
      case ButtonType.memory:
        bg = theme.memoryColor;
        fg = theme.memoryTextColor;
        break;
      case ButtonType.utility:
        bg = theme.utilityColor;
        fg = theme.utilityTextColor;
        break;
    }
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        textStyle: const TextStyle(fontSize: 18),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      ),
      child: Text(label, style: TextStyle(color: fg)),
    );
  }
}
