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

    final shiftColor = Colors.amber;
    final alphaColor = Colors.redAccent;

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ElevatedButton(
        onPressed: () => onTap(shiftState),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child: SizedBox.expand(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Main label (center)
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              // Secondary (SHIFT) label - top left
              if (secondaryLabel != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Text(
                    secondaryLabel!,
                    style: TextStyle(
                      color: shiftColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              // Tertiary (ALPHA) label - top right
              if (tertiaryLabel != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Text(
                    tertiaryLabel!,
                    style: TextStyle(
                      color: alphaColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
