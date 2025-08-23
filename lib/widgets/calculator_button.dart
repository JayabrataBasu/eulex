import 'package:flutter/material.dart';
import '../app/app_state.dart';
import '../app/theme.dart';

class CalculatorButton extends StatelessWidget {
  final String label;
  final String? secondaryLabel;
  final String? tertiaryLabel;
  final void Function(ShiftState shiftState) onTap;
  final ButtonType type;
  final CalculatorTheme theme;
  final bool isShift;
  final ShiftState shiftState;

  const CalculatorButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.type,
    required this.theme,
    this.secondaryLabel,
    this.tertiaryLabel,
    this.isShift = false,
    this.shiftState = ShiftState.inactive,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (type) {
      case ButtonType.number:
        backgroundColor = theme.numberButtonColor;
        textColor = theme.numberTextColor;
        break;
      case ButtonType.operator:
        backgroundColor = theme.operatorButtonColor;
        textColor = theme.operatorTextColor;
        break;
      case ButtonType.function:
        backgroundColor = theme.functionButtonColor;
        textColor = theme.functionTextColor;
        break;
      case ButtonType.utility:
        backgroundColor = isShift ? Colors.amber : theme.utilityButtonColor;
        textColor = isShift ? Colors.black : theme.utilityTextColor;
        break;
      case ButtonType.memory:
        backgroundColor = theme.memoryButtonColor;
        textColor = theme.memoryTextColor;
        break;
    }

    // Define colors for shift and alpha labels
    final shiftColor = Colors.amber;
    final alphaColor = Colors.redAccent;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () => onTap(shiftState),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: Stack(
            children: [
              // Secondary (SHIFT) label - top left
              if (secondaryLabel != null)
                Positioned(
                  top: 4,
                  left: 6,
                  child: Text(
                    secondaryLabel!,
                    style: TextStyle(
                      fontSize: 10,
                      color: shiftColor.withOpacity(0.85),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              // Tertiary (ALPHA) label - top right
              if (tertiaryLabel != null)
                Positioned(
                  top: 4,
                  right: 6,
                  child: Text(
                    tertiaryLabel!,
                    style: TextStyle(
                      fontSize: 10,
                      color: alphaColor.withOpacity(0.85),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              // Main label - center
              Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
