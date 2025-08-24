import 'package:flutter/material.dart';

import '../../widgets/calculator_button.dart';
import '../../services/calculator_engine.dart';
import '../../services/angle_mode.dart';
import '../../app/theme.dart';
import '../../graphing_screen.dart';
import '../../app/app_state.dart';

class CalculatorScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final CalculatorTheme theme;
  final CalculatorThemeMode themeMode;

  const CalculatorScreen({
    super.key,
    required this.onToggleTheme,
    required this.theme,
    required this.themeMode,
  });

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _expressionController = TextEditingController();
  String _result = '';
  List<String> _history = [];
  AngleMode _angleMode = AngleMode.deg;
  bool isShiftActive = false;

  // Add state management for modes
  ShiftState _shiftState = ShiftState.inactive;
  OperatingMode _operatingMode = OperatingMode.comp;

  @override
  void dispose() {
    _expressionController.dispose();
    super.dispose();
  }

  void setShiftState(ShiftState newState) {
    setState(() {
      _shiftState = newState;
    });
  }

  void _insertAtCursor(String insertText) {
    final text = _expressionController.text;
    final selection = _expressionController.selection;
    final start = selection.start >= 0 ? selection.start : text.length;
    final end = selection.end >= 0 ? selection.end : text.length;
    final newText = text.replaceRange(start, end, insertText);
    final newSelection = start + insertText.length;
    _expressionController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newSelection),
    );
  }

  void _insertAtCursorWithSelection(String insertText, int cursorOffset) {
    final text = _expressionController.text;
    final selection = _expressionController.selection;
    final start = selection.start >= 0 ? selection.start : text.length;
    final end = selection.end >= 0 ? selection.end : text.length;
    final newText = text.replaceRange(start, end, insertText);
    final newSelection = start + cursorOffset;
    _expressionController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newSelection),
    );
  }

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _expressionController.clear();
        _result = '';
      } else if (value == '=') {
        CalculatorEngine.setAngleMode(_angleMode);
        try {
          _result = CalculatorEngine.evaluate(_expressionController.text);
          if (_result != 'Error') {
            _history.insert(0, '${_expressionController.text} = $_result');
            if (_history.length > 15) _history.removeLast();
          }
        } on SyntaxError catch (e) {
          _result = e.toString();
        } on MathError catch (e) {
          _result = e.toString();
        } catch (e) {
          _result = "Unknown error.";
        }
      } else if (value == 'Ans') {
        _insertAtCursor(CalculatorEngine.lastResult);
      } else if (value == 'π') {
        _insertAtCursor('π');
      } else if (value == 'EXP') {
        _insertAtCursor('EXP');
      } else if (value == 'x²') {
        _insertAtCursor('^2');
      } else if (value == 'xʸ') {
        _insertAtCursor('^');
      } else if (value == '√') {
        _insertAtCursor('sqrt(');
      } else if (value == 'log') {
        _insertAtCursor('log(');
      } else if (value == 'ln') {
        _insertAtCursor('ln(');
      } else if ({
        'sin',
        'cos',
        'tan',
        'asin',
        'acos',
        'atan',
        'sinh',
        'cosh',
        'tanh',
      }.contains(value)) {
        _insertAtCursor('$value(');
      } else if (value == 'MC') {
        CalculatorEngine.memoryClear();
      } else if (value == 'MR') {
        final mem = CalculatorEngine.memoryRecall();
        _insertAtCursor(mem);
        _result = mem;
      } else if (value == 'M+') {
        CalculatorEngine.memoryAdd(_result.isNotEmpty ? _result : '0');
      } else if (value == 'M-') {
        CalculatorEngine.memorySubtract(_result.isNotEmpty ? _result : '0');
      } else if (value == 'MODE') {
        _angleMode =
            AngleMode.values[(_angleMode.index + 1) % AngleMode.values.length];
      } else if (value == 'SHIFT') {
        isShiftActive = !isShiftActive;
      } else if (value == 'd/dx') {
        // Insert template: d/dx(|x=)
        _insertAtCursorWithSelection('d/dx(|x=)', 5);
      } else {
        _insertAtCursor(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return Scaffold(
      backgroundColor: theme.themeData.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Eulex Calculator'),
        backgroundColor: theme.themeData.appBarTheme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.show_chart),
            tooltip: 'Graphing',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GraphingScreen(theme: theme),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480, maxHeight: 720),
          decoration: BoxDecoration(
            color: theme.themeData.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.18 * 255).toInt()),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Display
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.displayBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _expressionController,
                            style: TextStyle(
                              fontSize: 28,
                              color: theme.numberTextColor,
                            ),
                            textAlign: TextAlign.right,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isCollapsed: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        if (CalculatorEngine.hasMemory())
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'M',
                              style: TextStyle(
                                fontSize: 20,
                                color: theme.memoryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          _angleMode.label,
                          style: TextStyle(
                            fontSize: 16,
                            color: widget.theme.operatorColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isShiftActive)
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(
                              'SHIFT',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _result,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: theme.operatorColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Buttons
              Expanded(
                child: Column(
                  children: [
                    // ROW 1: SHIFT, ALPHA, ←, →, MODE, 2nd
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: CalculatorButton(
                              label: 'SHIFT',
                              onTap: (_) {},
                              type: ButtonType.utility,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: 'ALPHA',
                              onTap: (_) {},
                              type: ButtonType.utility,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: Icon(Icons.arrow_back_ios_new),
                            flex: 2,
                          ),
                          Expanded(
                            child: Icon(Icons.arrow_forward_ios),
                            flex: 2,
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: 'MODE',
                              onTap: (_) {},
                              type: ButtonType.utility,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: '2nd',
                              onTap: (_) {},
                              type: ButtonType.utility,
                              theme: theme,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ROW 2: SOLVE =, d/dx ∫:, ...
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: CalculatorButton(
                              label: 'SOLVE =',
                              onTap: (_) {},
                              type: ButtonType.function,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: 'd/dx ∫:',
                              onTap: (_) {},
                              type: ButtonType.function,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: '',
                              onTap: (_) {},
                              type: ButtonType.utility,
                              theme: theme,
                            ),
                          ), // Placeholder
                          Expanded(
                            child: CalculatorButton(
                              label: 'x!',
                              secondaryLabel: 'Π',
                              onTap: (_) {},
                              type: ButtonType.function,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: 'x⁻¹',
                              secondaryLabel: '∫',
                              onTap: (_) {},
                              type: ButtonType.function,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: 'Logₓ',
                              secondaryLabel: '10ˣ',
                              onTap: (_) {},
                              type: ButtonType.function,
                              theme: theme,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ROW 3: CALC, ∫dx, mod, ...
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: CalculatorButton(
                              label: 'CALC',
                              onTap: (_) {},
                              type: ButtonType.function,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: '∫dx',
                              secondaryLabel: 'Σ',
                              onTap: (_) {},
                              type: ButtonType.function,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: 'mod',
                              secondaryLabel: '(',
                              onTap: (_) {},
                              type: ButtonType.function,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: 'x³',
                              secondaryLabel: '³√',
                              onTap: (_) {},
                              type: ButtonType.function,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: 'x²',
                              secondaryLabel: '√',
                              onTap: (_) {},
                              type: ButtonType.function,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: 'x⁻²',
                              secondaryLabel: 'eˣ',
                              onTap: (_) {},
                              type: ButtonType.function,
                              theme: theme,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ROW 4: x÷y, √x, x², xʸ, Log, Ln
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: CalculatorButton(
                              label: 'x÷y',
                              secondaryLabel: 'a b/c',
                              onTap: (_) {},
                              type: ButtonType.function,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: '√x',
                              secondaryLabel: '<',
                              onTap: (_) {},
                              type: ButtonType.function,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: 'x²',
                              secondaryLabel: '>',
                              onTap: (_) {},
                              type: ButtonType.function,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: 'xʸ',
                              secondaryLabel: 'log',
                              onTap: (_) {},
                              type: ButtonType.function,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: 'Log',
                              secondaryLabel: '10ˣ',
                              onTap: (_) {},
                              type: ButtonType.function,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: 'Ln',
                              secondaryLabel: 'eˣ',
                              onTap: (_) {},
                              type: ButtonType.function,
                              theme: theme,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ROW 5: Example alpha/numeric/trig row
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: CalculatorButton(
                              label: 'a',
                              secondaryLabel: 'FACT',
                              tertiaryLabel: 'b',
                              onTap: (_) {},
                              type: ButtonType.number,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: 'b',
                              secondaryLabel: 'FACT',
                              tertiaryLabel: 'c',
                              onTap: (_) {},
                              type: ButtonType.number,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: 'c',
                              secondaryLabel: 'FACT',
                              tertiaryLabel: 'x',
                              onTap: (_) {},
                              type: ButtonType.number,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: 'Sin',
                              secondaryLabel: 'Sin⁻¹',
                              tertiaryLabel: 'd',
                              onTap: (_) {},
                              type: ButtonType.function,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: 'Cos',
                              secondaryLabel: 'Cos⁻¹',
                              tertiaryLabel: 'e',
                              onTap: (_) {},
                              type: ButtonType.function,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: 'Tan',
                              secondaryLabel: 'Tan⁻¹',
                              tertiaryLabel: 'f',
                              onTap: (_) {},
                              type: ButtonType.function,
                              theme: theme,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ROW 6: Utility/angle row
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: CalculatorButton(
                              label: '(-)',
                              secondaryLabel: 'STO',
                              tertiaryLabel: 'CLRv',
                              onTap: (_) {},
                              type: ButtonType.utility,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: 'o,\'\'\'',
                              secondaryLabel: 'RCL',
                              tertiaryLabel: 'I',
                              onTap: (_) {},
                              type: ButtonType.utility,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: 'hyp',
                              secondaryLabel: 'ENG',
                              tertiaryLabel: 'Cot⁻¹',
                              onTap: (_) {},
                              type: ButtonType.function,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: '(',
                              secondaryLabel: ',',
                              tertiaryLabel: ')',
                              onTap: (_) {},
                              type: ButtonType.utility,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: ')',
                              secondaryLabel: '∫D',
                              tertiaryLabel: 'x',
                              onTap: (_) {},
                              type: ButtonType.utility,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: 'M-',
                              secondaryLabel: 'S⇔D',
                              tertiaryLabel: 'M+',
                              onTap: (_) {},
                              type: ButtonType.memory,
                              theme: theme,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ROW 7: 7 8 9 × CLR AC
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: CalculatorButton(
                              label: '7',
                              onTap: (_) {},
                              type: ButtonType.number,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: '8',
                              onTap: (_) {},
                              type: ButtonType.number,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: '9',
                              onTap: (_) {},
                              type: ButtonType.number,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: '×',
                              onTap: (_) {},
                              type: ButtonType.operator,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: 'CLR',
                              secondaryLabel: 'CONST',
                              tertiaryLabel: 'Conv',
                              onTap: (_) {},
                              type: ButtonType.utility,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: 'AC',
                              onTap: (_) {},
                              type: ButtonType.utility,
                              theme: theme,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ROW 8: 4 5 6 ÷ ← DEL
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: CalculatorButton(
                              label: '4',
                              onTap: (_) {},
                              type: ButtonType.number,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: '5',
                              onTap: (_) {},
                              type: ButtonType.number,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: '6',
                              onTap: (_) {},
                              type: ButtonType.number,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: '÷',
                              onTap: (_) {},
                              type: ButtonType.operator,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: '←',
                              secondaryLabel: 'SI',
                              tertiaryLabel: '∞',
                              onTap: (_) {},
                              type: ButtonType.utility,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: 'DEL',
                              onTap: (_) {},
                              type: ButtonType.utility,
                              theme: theme,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ROW 9: 1 2 3 + COPY Ans
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: CalculatorButton(
                              label: '1',
                              onTap: (_) {},
                              type: ButtonType.number,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: '2',
                              onTap: (_) {},
                              type: ButtonType.number,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: '3',
                              onTap: (_) {},
                              type: ButtonType.number,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: '+',
                              onTap: (_) {},
                              type: ButtonType.operator,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: 'COPY',
                              secondaryLabel: 'Paste',
                              tertiaryLabel: 'Ran#',
                              onTap: (_) {},
                              type: ButtonType.utility,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: 'Ans',
                              secondaryLabel: 'RanInt#',
                              tertiaryLabel: '=',
                              onTap: (_) {},
                              type: ButtonType.utility,
                              theme: theme,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ROW 10: 0 (wide), . Exp - PreAns =
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 2,
                            child: CalculatorButton(
                              label: '0',
                              onTap: (_) {},
                              type: ButtonType.number,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: '.',
                              onTap: (_) {},
                              type: ButtonType.number,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: 'Exp',
                              secondaryLabel: 'π',
                              tertiaryLabel: 'e',
                              onTap: (_) {},
                              type: ButtonType.function,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: '-',
                              onTap: (_) {},
                              type: ButtonType.operator,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            child: CalculatorButton(
                              label: 'PreAns',
                              secondaryLabel: 'History',
                              onTap: (_) {},
                              type: ButtonType.utility,
                              theme: theme,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: CalculatorButton(
                              label: '=',
                              onTap: (_) {},
                              type: ButtonType.operator,
                              theme: theme,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // History
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: theme.historyBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  reverse: true,
                  itemCount: _history.length,
                  itemBuilder: (context, idx) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 2,
                    ),
                    child: Text(
                      _history[idx],
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.numberTextColor.withAlpha(
                          (0.7 * 255).toInt(),
                        ),
                      ),
                    ),
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
