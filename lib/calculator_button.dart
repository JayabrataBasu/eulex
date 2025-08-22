import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isOperator;

  const CalculatorButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isOperator = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isOperator
            ? const Color(0xFF6C61F6)
            : const Color(0xFF292D36),
        foregroundColor: isOperator
            ? Colors.white
            : Colors.white70,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
        textStyle: const TextStyle(fontSize: 20),
      ),
      child: Text(label),
    );
  }
}
