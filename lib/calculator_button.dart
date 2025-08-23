import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isOperator;
  final Color backgroundColor;
  final Color textColor;

  const CalculatorButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isOperator = false,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isFunction = ['sin', 'cos', 'tan', 'log', '√'].contains(label);
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
        textStyle: TextStyle(fontSize: isFunction ? 16 : 20),
        padding: isFunction
            ? const EdgeInsets.symmetric(vertical: 8, horizontal: 2)
            : null,
      ),
      child: Text(label, style: TextStyle(color: textColor)),
    );
  }
}
