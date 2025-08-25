// lib/features/calculator/calculator_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_state.dart';
import '../../app/theme.dart';
import '../../widgets/calculator_button.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  // Helper to determine which function to execute based on ShiftState
  void _onFunctionButtonPressed(
    BuildContext context, {
    required String primaryValue,
    String? shiftValue,
    String? alphaValue,
  }) {
    final calc = context.read<CalculatorState>();
    // Store mode takes precedence when in alpha state
    if (calc.operationMode == OperationMode.storing && alphaValue != null) {
      calc.storeVariable(alphaValue);
      return;
    }
    switch (calc.shiftState) {
      case ShiftState.shift:
        if (shiftValue != null) calc.handleFunctionInput(shiftValue);
        break;
      case ShiftState.alpha:
        if (alphaValue != null) {
          // recall variable if exists
          if (calc.variables.containsKey(alphaValue.toLowerCase())) {
            calc.recallVariable(alphaValue);
          } else {
            calc.handleFunctionInput(alphaValue);
          }
        }
        break;
      case ShiftState.normal:
        if (primaryValue == 'STO') {
          calc.activateStoreMode();
        } else if (primaryValue == 'RCL' && alphaValue != null) {
          calc.recallVariable(alphaValue);
        } else {
          calc.handleFunctionInput(primaryValue);
        }
        break;
    }
  }

  Widget _buildStatusIndicator(CalculatorState calc) {
    final state = calc.shiftState;
    String text;
    Color color;
    switch (state) {
      case ShiftState.shift:
        text = 'SHIFT';
        color = calc.currentTheme.shiftLabelText;
        break;
      case ShiftState.alpha:
        text = calc.operationMode == OperationMode.storing ? 'STO →' : 'ALPHA';
        color = calc.currentTheme.alphaLabelText;
        break;
      default:
        return const SizedBox.shrink();
    }
    return Text(
      text,
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use .watch here so the UI rebuilds when state changes
    final calculatorState = context.watch<CalculatorState>();
    final theme = calculatorState.currentTheme;

    Widget buildButtonRow(List<Widget> buttons) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: buttons.map((button) => Expanded(child: button)).toList(),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // DISPLAY AREA
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.displayBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatusIndicator(calculatorState),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          tooltip: 'Cycle Theme',
                          icon: const Icon(Icons.palette_outlined),
                          onPressed: () => calculatorState.cycleTheme(),
                        ),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextField(
                          controller: calculatorState.controller,
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 48),
                          maxLines: 1,
                          decoration: const InputDecoration.collapsed(
                            hintText: '',
                          ),
                          showCursor: true,
                          autofocus: false,
                          readOnly: true, // Input only via buttons
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // BUTTON PAD
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    buildButtonRow([
                      CalculatorButton(
                        primaryLabel: 'SHIFT',
                        buttonColor: theme.shiftButton,
                        onPressed: () =>
                            calculatorState.setShiftState(ShiftState.shift),
                      ),
                      CalculatorButton(
                        primaryLabel: 'ALPHA',
                        buttonColor: theme.alphaButton,
                        onPressed: () =>
                            calculatorState.setShiftState(ShiftState.alpha),
                      ),
                      // NEW: Angle mode button
                      CalculatorButton(
                        primaryLabel: calculatorState.angleMode.name
                            .toUpperCase(),
                        shiftLabel: 'DRG',
                        buttonColor: theme.functionButton,
                        onPressed: () => calculatorState.cycleAngleMode(),
                      ),
                      CalculatorButton(
                        primaryLabel: '◀',
                        buttonColor: theme.operatorButton,
                        onPressed: () => calculatorState.moveCursor(-1),
                      ),
                      CalculatorButton(
                        primaryLabel: '▶',
                        buttonColor: theme.operatorButton,
                        onPressed: () => calculatorState.moveCursor(1),
                      ),
                      CalculatorButton(
                        primaryLabel: 'MODE',
                        shiftLabel: 'SETUP',
                        buttonColor: theme.functionButton,
                        onPressed: () => _onFunctionButtonPressed(
                          context,
                          primaryValue: 'MODE',
                          shiftValue: 'SETUP',
                        ),
                      ),
                      CalculatorButton(
                        primaryLabel: '2nd',
                        shiftLabel: 'QUIT',
                        buttonColor: theme.functionButton,
                        onPressed: () => _onFunctionButtonPressed(
                          context,
                          primaryValue: '2nd',
                          shiftValue: 'QUIT',
                        ),
                      ),
                    ]),
                    buildButtonRow([
                      CalculatorButton(
                        primaryLabel: 'd/dx',
                        shiftLabel: 'SOLVE',
                        buttonColor: theme.functionButton,
                        onPressed: () => _onFunctionButtonPressed(
                          context,
                          primaryValue: 'd/dx(',
                          shiftValue: 'SOLVE',
                        ),
                      ),
                      CalculatorButton(
                        primaryLabel: '∫dx',
                        buttonColor: theme.functionButton,
                        onPressed: () => _onFunctionButtonPressed(
                          context,
                          primaryValue: '∫(',
                        ),
                      ),
                      CalculatorButton(
                        primaryLabel: 'x³',
                        shiftLabel: 'x!',
                        buttonColor: theme.functionButton,
                        onPressed: () => _onFunctionButtonPressed(
                          context,
                          primaryValue: '³',
                          shiftValue: '!',
                        ),
                      ),
                      CalculatorButton(
                        primaryLabel: '▲',
                        buttonColor: theme.operatorButton,
                        onPressed: () {},
                      ),
                      CalculatorButton(
                        primaryLabel: 'x⁻¹',
                        shiftLabel: 'Σ',
                        buttonColor: theme.functionButton,
                        onPressed: () => _onFunctionButtonPressed(
                          context,
                          primaryValue: '⁻¹',
                          shiftValue: 'Σ(',
                        ),
                      ),
                      CalculatorButton(
                        primaryLabel: 'logₐx',
                        shiftLabel: 'Π',
                        buttonColor: theme.functionButton,
                        onPressed: () => _onFunctionButtonPressed(
                          context,
                          primaryValue: 'log(',
                          shiftValue: 'Π(',
                        ),
                      ),
                    ]),
                    buildButtonRow([
                      CalculatorButton(
                        primaryLabel: 'CALC',
                        shiftLabel: '÷R',
                        buttonColor: theme.functionButton,
                        onPressed: () => _onFunctionButtonPressed(
                          context,
                          primaryValue: 'CALC',
                          shiftValue: '÷R',
                        ),
                      ),
                      CalculatorButton(
                        primaryLabel: '³√x',
                        shiftLabel: 'mod',
                        buttonColor: theme.functionButton,
                        onPressed: () => _onFunctionButtonPressed(
                          context,
                          primaryValue: '³√(',
                          shiftValue: 'mod(',
                        ),
                      ),
                      CalculatorButton(
                        primaryLabel: '√x',
                        buttonColor: theme.functionButton,
                        onPressed: () => _onFunctionButtonPressed(
                          context,
                          primaryValue: '√(',
                        ),
                      ),
                      CalculatorButton(
                        primaryLabel: 'x²',
                        buttonColor: theme.functionButton,
                        onPressed: () => _onFunctionButtonPressed(
                          context,
                          primaryValue: '²',
                        ),
                      ),
                      CalculatorButton(
                        primaryLabel: 'xʸ',
                        shiftLabel: '¹⁰ˣ',
                        alphaLabel: 't',
                        buttonColor: theme.functionButton,
                        onPressed: () => _onFunctionButtonPressed(
                          context,
                          primaryValue: '^',
                          shiftValue: '10^',
                          alphaValue: 'T',
                        ),
                      ),
                      CalculatorButton(
                        primaryLabel: 'Log',
                        shiftLabel: 'e',
                        alphaLabel: 'e',
                        buttonColor: theme.functionButton,
                        onPressed: () => _onFunctionButtonPressed(
                          context,
                          primaryValue: 'log₁₀(',
                          shiftValue: 'e',
                          alphaValue: 'e',
                        ),
                      ),
                      CalculatorButton(
                        primaryLabel: 'Ln',
                        buttonColor: theme.functionButton,
                        onPressed: () => _onFunctionButtonPressed(
                          context,
                          primaryValue: 'ln(',
                        ),
                      ),
                    ]),
                    buildButtonRow([
                      CalculatorButton(
                        primaryLabel: '(-)',
                        alphaLabel: 'A',
                        buttonColor: theme.functionButton,
                        onPressed: () => _onFunctionButtonPressed(
                          context,
                          primaryValue: '-',
                          alphaValue: 'A',
                        ),
                      ),
                      CalculatorButton(
                        primaryLabel: '°\'"',
                        shiftLabel: 'FACT',
                        alphaLabel: 'B',
                        buttonColor: theme.functionButton,
                        onPressed: () => _onFunctionButtonPressed(
                          context,
                          primaryValue: '°',
                          shiftValue: '!',
                          alphaValue: 'B',
                        ),
                      ),
                      CalculatorButton(
                        primaryLabel: 'hyp',
                        alphaLabel: 'C',
                        buttonColor: theme.functionButton,
                        onPressed: () => _onFunctionButtonPressed(
                          context,
                          primaryValue: 'hyp',
                          alphaValue: 'C',
                        ),
                      ),
                      CalculatorButton(
                        primaryLabel: 'Sin',
                        shiftLabel: 'Sin⁻¹',
                        alphaLabel: 'D',
                        buttonColor: theme.functionButton,
                        onPressed: () => _onFunctionButtonPressed(
                          context,
                          primaryValue: 'sin(',
                          shiftValue: 'asin(',
                          alphaValue: 'D',
                        ),
                      ),
                      CalculatorButton(
                        primaryLabel: 'Cos',
                        shiftLabel: 'Cos⁻¹',
                        alphaLabel: 'E',
                        buttonColor: theme.functionButton,
                        onPressed: () => _onFunctionButtonPressed(
                          context,
                          primaryValue: 'cos(',
                          shiftValue: 'acos(',
                          alphaValue: 'E',
                        ),
                      ),
                      CalculatorButton(
                        primaryLabel: 'Tan',
                        shiftLabel: 'Tan⁻¹',
                        alphaLabel: 'F',
                        buttonColor: theme.functionButton,
                        onPressed: () => _onFunctionButtonPressed(
                          context,
                          primaryValue: 'tan(',
                          shiftValue: 'atan(',
                          alphaValue: 'F',
                        ),
                      ),
                    ]),
                    buildButtonRow([
                      CalculatorButton(
                        primaryLabel: 'STO',
                        shiftLabel: 'CLRV',
                        buttonColor: theme.functionButton,
                        onPressed: () => _onFunctionButtonPressed(
                          context,
                          primaryValue: 'STO',
                          shiftValue: 'CLRV',
                        ),
                      ),
                      CalculatorButton(
                        primaryLabel: 'RCL',
                        shiftLabel: 'i',
                        alphaLabel: 'X',
                        buttonColor: theme.functionButton,
                        onPressed: () => _onFunctionButtonPressed(
                          context,
                          primaryValue: 'RCL',
                          shiftValue: 'i',
                          alphaValue: 'X',
                        ),
                      ),
                      CalculatorButton(
                        primaryLabel: 'ENG',
                        shiftLabel: 'Cot',
                        alphaLabel: 'Y',
                        buttonColor: theme.functionButton,
                        onPressed: () => _onFunctionButtonPressed(
                          context,
                          primaryValue: 'ENG',
                          shiftValue: 'cot(',
                          alphaValue: 'Y',
                        ),
                      ),
                      CalculatorButton(
                        primaryLabel: '(',
                        shiftLabel: 'Cot⁻¹',
                        alphaLabel: 'Z',
                        buttonColor: theme.functionButton,
                        onPressed: () => _onFunctionButtonPressed(
                          context,
                          primaryValue: '(',
                          shiftValue: 'acot(',
                          alphaValue: 'Z',
                        ),
                      ),
                      CalculatorButton(
                        primaryLabel: ')',
                        buttonColor: theme.functionButton,
                        onPressed: () => calculatorState.appendInput(')'),
                      ),
                      CalculatorButton(
                        primaryLabel: 'S⇔D',
                        shiftLabel: '%',
                        alphaLabel: 'M-',
                        buttonColor: theme.functionButton,
                        onPressed: () => _onFunctionButtonPressed(
                          context,
                          primaryValue: 'S⇔D',
                          shiftValue: '%',
                          alphaValue: 'M-',
                        ),
                      ),
                      CalculatorButton(
                        primaryLabel: 'M+',
                        alphaLabel: 'M',
                        buttonColor: AppColors.functionButton,
                        onPressed: () => _onFunctionButtonPressed(
                          context,
                          primaryValue: 'M+',
                          alphaValue: 'M',
                        ),
                      ),
                    ]),
                    buildButtonRow([
                      CalculatorButton(
                        primaryLabel: '7',
                        onPressed: () => calculatorState.appendInput('7'),
                      ),
                      CalculatorButton(
                        primaryLabel: '8',
                        onPressed: () => calculatorState.appendInput('8'),
                      ),
                      CalculatorButton(
                        primaryLabel: '9',
                        onPressed: () => calculatorState.appendInput('9'),
                      ),
                      CalculatorButton(
                        primaryLabel: 'DEL',
                        buttonColor: theme.controlButton,
                        onPressed: () => calculatorState.backspace(),
                      ),
                      CalculatorButton(
                        primaryLabel: 'AC',
                        shiftLabel: 'CLR ALL',
                        buttonColor: theme.controlButton,
                        onPressed: () => calculatorState.allClear(),
                      ),
                    ]),
                    buildButtonRow([
                      CalculatorButton(
                        primaryLabel: '4',
                        onPressed: () => calculatorState.appendInput('4'),
                      ),
                      CalculatorButton(
                        primaryLabel: '5',
                        onPressed: () => calculatorState.appendInput('5'),
                      ),
                      CalculatorButton(
                        primaryLabel: '6',
                        onPressed: () => calculatorState.appendInput('6'),
                      ),
                      CalculatorButton(
                        primaryLabel: '×',
                        onPressed: () => calculatorState.appendInput('×'),
                      ),
                      CalculatorButton(
                        primaryLabel: '÷',
                        onPressed: () => calculatorState.appendInput('÷'),
                      ),
                    ]),
                    buildButtonRow([
                      CalculatorButton(
                        primaryLabel: '1',
                        onPressed: () => calculatorState.appendInput('1'),
                      ),
                      CalculatorButton(
                        primaryLabel: '2',
                        onPressed: () => calculatorState.appendInput('2'),
                      ),
                      CalculatorButton(
                        primaryLabel: '3',
                        onPressed: () => calculatorState.appendInput('3'),
                      ),
                      CalculatorButton(
                        primaryLabel: '＋',
                        onPressed: () => calculatorState.appendInput('＋'),
                      ),
                      CalculatorButton(
                        primaryLabel: '－',
                        onPressed: () => calculatorState.appendInput('－'),
                      ),
                    ]),
                    buildButtonRow([
                      CalculatorButton(
                        primaryLabel: '0',
                        onPressed: () => calculatorState.appendInput('0'),
                      ),
                      CalculatorButton(
                        primaryLabel: '.',
                        onPressed: () => calculatorState.appendInput('.'),
                      ),
                      CalculatorButton(
                        primaryLabel: 'Exp',
                        shiftLabel: 'π',
                        alphaLabel: 'e',
                        buttonColor: AppColors.functionButton,
                        onPressed: () => _onFunctionButtonPressed(
                          context,
                          primaryValue: 'E',
                          shiftValue: 'π',
                          alphaValue: 'e',
                        ),
                      ),
                      CalculatorButton(
                        primaryLabel: 'Ans',
                        buttonColor: AppColors.functionButton,
                        onPressed: () => _onFunctionButtonPressed(
                          context,
                          primaryValue: 'Ans',
                        ),
                      ),
                      CalculatorButton(
                        primaryLabel: '=',
                        shiftLabel: 'History',
                        buttonColor: AppColors.operatorButton,
                        onPressed: () => calculatorState.evaluateExpression(),
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
