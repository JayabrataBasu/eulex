// lib/widgets/calculator_button.dart

import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  const CalculatorButton({
    super.key,
    required this.primaryLabel,
    this.shiftLabel,
    this.alphaLabel,
    this.buttonColor,
    this.primaryLabelColor,
    required this.onPressed,
  });

  final String primaryLabel;
  final String? shiftLabel;
  final String? alphaLabel;
  final Color? buttonColor;
  final Color? primaryLabelColor;
  final VoidCallback onPressed;

  // Define colors for the secondary labels, matching the target image
  static const Color shiftTextColor = Color(0xFFD39823);
  static const Color alphaTextColor = Color(0xFFC0392B);

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Add padding for spacing between buttons
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              buttonColor ?? Theme.of(context).colorScheme.secondaryContainer,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Main label in the center
            Center(
              child: Text(
                primaryLabel,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color:
                      primaryLabelColor ??
                      Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
            ),

            // SHIFT label (top left)
            if (shiftLabel != null)
              Positioned(
                top: 0,
                left: 0,
                child: Text(
                  shiftLabel!,
                  style: const TextStyle(
                    fontSize: 10,
                    color: shiftTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            // ALPHA label (top right)
            if (alphaLabel != null)
              Positioned(
                top: 0,
                right: 0,
                child: Text(
                  alphaLabel!,
                  style: const TextStyle(
                    fontSize: 10,
                    color: alphaTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
