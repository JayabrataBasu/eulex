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

  // Example button definitions for a non-uniform layout.
  // You can expand this list as needed for your target UI.
  List<List<Map<String, dynamic>>> get _buttonRows => [
    [
      {
        'label': 'AC',
        'value': 'C',
        'type': ButtonType.utility,
        'secondary': null,
        'tertiary': null,
      },
      {
        'label': '(',
        'value': '(',
        'type': ButtonType.utility,
        'secondary': null,
        'tertiary': null,
      },
      {
        'label': ')',
        'value': ')',
        'type': ButtonType.utility,
        'secondary': null,
        'tertiary': null,
      },
      {
        'label': '%',
        'value': '%',
        'type': ButtonType.operator,
        'secondary': null,
        'tertiary': null,
      },
      {
        'label': '÷',
        'value': '÷',
        'type': ButtonType.operator,
        'secondary': null,
        'tertiary': null,
      },
      {
        'label': 'Shift',
        'value': 'SHIFT',
        'type': ButtonType.utility,
        'secondary': null,
        'tertiary': null,
      },
    ],
    [
      {
        'label': '7',
        'value': '7',
        'type': ButtonType.number,
        'secondary': null,
        'tertiary': null,
      },
      {
        'label': '8',
        'value': '8',
        'type': ButtonType.number,
        'secondary': null,
        'tertiary': null,
      },
      {
        'label': '9',
        'value': '9',
        'type': ButtonType.number,
        'secondary': null,
        'tertiary': null,
      },
      {
        'label': '×',
        'value': '×',
        'type': ButtonType.operator,
        'secondary': null,
        'tertiary': null,
      },
      {
        'label': 'sin',
        'value': 'sin',
        'type': ButtonType.function,
        'secondary': 'sin⁻¹',
        'tertiary': null,
      },
      {
        'label': 'cos',
        'value': 'cos',
        'type': ButtonType.function,
        'secondary': 'cos⁻¹',
        'tertiary': null,
      },
    ],
    [
      {
        'label': '4',
        'value': '4',
        'type': ButtonType.number,
        'secondary': null,
        'tertiary': null,
      },
      {
        'label': '5',
        'value': '5',
        'type': ButtonType.number,
        'secondary': null,
        'tertiary': null,
      },
      {
        'label': '6',
        'value': '6',
        'type': ButtonType.number,
        'secondary': null,
        'tertiary': null,
      },
      {
        'label': '−',
        'value': '−',
        'type': ButtonType.operator,
        'secondary': null,
        'tertiary': null,
      },
      {
        'label': 'tan',
        'value': 'tan',
        'type': ButtonType.function,
        'secondary': 'tan⁻¹',
        'tertiary': null,
      },
      {
        'label': '√',
        'value': '√',
        'type': ButtonType.function,
        'secondary': 'sinh',
        'tertiary': null,
      },
    ],
    [
      {
        'label': '1',
        'value': '1',
        'type': ButtonType.number,
        'secondary': null,
        'tertiary': null,
      },
      {
        'label': '2',
        'value': '2',
        'type': ButtonType.number,
        'secondary': null,
        'tertiary': null,
      },
      {
        'label': '3',
        'value': '3',
        'type': ButtonType.number,
        'secondary': null,
        'tertiary': null,
      },
      {
        'label': '+',
        'value': '+',
        'type': ButtonType.operator,
        'secondary': null,
        'tertiary': null,
      },
      {
        'label': 'x²',
        'value': '^2',
        'type': ButtonType.function,
        'secondary': 'cosh',
        'tertiary': null,
      },
      {
        'label': 'xʸ',
        'value': '^',
        'type': ButtonType.function,
        'secondary': 'tanh',
        'tertiary': null,
      },
    ],
    [
      {
        'label': '0',
        'value': '0',
        'type': ButtonType.number,
        'secondary': null,
        'tertiary': null,
      },
      {
        'label': '.',
        'value': '.',
        'type': ButtonType.number,
        'secondary': null,
        'tertiary': null,
      },
      {
        'label': 'Ans',
        'value': 'Ans',
        'type': ButtonType.utility,
        'secondary': null,
        'tertiary': null,
      },
      {
        'label': '=',
        'value': '=',
        'type': ButtonType.operator,
        'secondary': null,
        'tertiary': null,
      },
      {
        'label': 'log',
        'value': 'log',
        'type': ButtonType.function,
        'secondary': null,
        'tertiary': null,
      },
      {
        'label': 'ln',
        'value': 'ln',
        'type': ButtonType.function,
        'secondary': null,
        'tertiary': null,
      },
    ],
    [
      {
        'label': 'MC',
        'value': 'MC',
        'type': ButtonType.memory,
        'secondary': null,
        'tertiary': null,
      },
      {
        'label': 'MR',
        'value': 'MR',
        'type': ButtonType.memory,
        'secondary': null,
        'tertiary': null,
      },
      {
        'label': 'M+',
        'value': 'M+',
        'type': ButtonType.memory,
        'secondary': null,
        'tertiary': null,
      },
      {
        'label': 'M−',
        'value': 'M-',
        'type': ButtonType.memory,
        'secondary': null,
        'tertiary': null,
      },
      {
        'label': 'π',
        'value': 'π',
        'type': ButtonType.function,
        'secondary': null,
        'tertiary': null,
      },
      {
        'label': 'Mode\n${_angleMode.label}',
        'value': 'MODE',
        'type': ButtonType.utility,
        'secondary': null,
        'tertiary': null,
      },
    ],
    [
      {
        'label': 'd/dx',
        'value': 'd/dx',
        'type': ButtonType.function,
        'secondary': null,
        'tertiary': null,
      },
      // ...add ∫dx or other calculus buttons as needed...
    ],
  ];

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
                    for (final row in _buttonRows)
                      Expanded(
                        child: Row(
                          children: [
                            for (final btn in row)
                              Expanded(
                                child: CalculatorButton(
                                  label: btn['label'],
                                  secondaryLabel: btn['secondary'],
                                  tertiaryLabel: btn['tertiary'],
                                  onTap: (_) => _onButtonPressed(btn['value']),
                                  type: btn['type'],
                                  theme: theme,
                                  isShift: btn['value'] == 'SHIFT'
                                      ? isShiftActive
                                      : false,
                                  // You can pass shiftState if needed
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
