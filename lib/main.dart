import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:math_expressions/math_expressions.dart';
import 'calculator_button.dart';
import 'calculator_engine.dart';
import 'theme.dart';
import 'angle_mode.dart';
import 'graphing_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CalculatorThemeMode _themeMode = CalculatorThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode = CalculatorThemeMode
          .values[(_themeMode.index + 1) % CalculatorThemeMode.values.length];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = calculatorThemes[_themeMode]!;
    return MaterialApp(
      title: 'Eulex Calculator',
      theme: theme.themeData,
      home: CalculatorPage(
        onToggleTheme: _toggleTheme,
        theme: theme,
        themeMode: _themeMode,
      ),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final CalculatorTheme theme;
  final CalculatorThemeMode themeMode;
  const CalculatorPage({
    super.key,
    required this.onToggleTheme,
    required this.theme,
    required this.themeMode,
  });
  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final TextEditingController _expressionController = TextEditingController();
  String _result = '';
  List<String> _history = [];
  AngleMode _angleMode = AngleMode.deg;
  bool isShiftActive = false;

  @override
  void dispose() {
    _expressionController.dispose();
    super.dispose();
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
      } else {
        _insertAtCursor(value);
      }
    });
  }

  List<List<Map<String, dynamic>>> get _buttonGrid {
    // Shift toggles between normal and inverse/hyperbolic functions
    return [
      [
        {'label': 'AC', 'value': 'C', 'type': ButtonType.utility},
        {'label': '(', 'value': '(', 'type': ButtonType.utility},
        {'label': ')', 'value': ')', 'type': ButtonType.utility},
        {'label': '%', 'value': '%', 'type': ButtonType.operator},
        {'label': '÷', 'value': '÷', 'type': ButtonType.operator},
        {
          'label': isShiftActive ? 'Shift*' : 'Shift',
          'value': 'SHIFT',
          'type': ButtonType.utility,
        },
      ],
      [
        {'label': '7', 'value': '7', 'type': ButtonType.number},
        {'label': '8', 'value': '8', 'type': ButtonType.number},
        {'label': '9', 'value': '9', 'type': ButtonType.number},
        {'label': '×', 'value': '×', 'type': ButtonType.operator},
        {
          'label': isShiftActive ? 'asin' : 'sin',
          'value': isShiftActive ? 'asin' : 'sin',
          'type': ButtonType.function,
        },
        {
          'label': isShiftActive ? 'acos' : 'cos',
          'value': isShiftActive ? 'acos' : 'cos',
          'type': ButtonType.function,
        },
      ],
      [
        {'label': '4', 'value': '4', 'type': ButtonType.number},
        {'label': '5', 'value': '5', 'type': ButtonType.number},
        {'label': '6', 'value': '6', 'type': ButtonType.number},
        {'label': '−', 'value': '−', 'type': ButtonType.operator},
        {
          'label': isShiftActive ? 'atan' : 'tan',
          'value': isShiftActive ? 'atan' : 'tan',
          'type': ButtonType.function,
        },
        {
          'label': isShiftActive ? 'sinh' : '√',
          'value': isShiftActive ? 'sinh' : '√',
          'type': ButtonType.function,
        },
      ],
      [
        {'label': '1', 'value': '1', 'type': ButtonType.number},
        {'label': '2', 'value': '2', 'type': ButtonType.number},
        {'label': '3', 'value': '3', 'type': ButtonType.number},
        {'label': '+', 'value': '+', 'type': ButtonType.operator},
        {
          'label': isShiftActive ? 'cosh' : 'x²',
          'value': isShiftActive ? 'cosh' : 'x²',
          'type': ButtonType.function,
        },
        {
          'label': isShiftActive ? 'tanh' : 'xʸ',
          'value': isShiftActive ? 'tanh' : 'xʸ',
          'type': ButtonType.function,
        },
      ],
      [
        {'label': '0', 'value': '0', 'type': ButtonType.number},
        {'label': '.', 'value': '.', 'type': ButtonType.number},
        {'label': 'Ans', 'value': 'Ans', 'type': ButtonType.utility},
        {'label': '=', 'value': '=', 'type': ButtonType.operator},
        {'label': 'log', 'value': 'log', 'type': ButtonType.function},
        {'label': 'ln', 'value': 'ln', 'type': ButtonType.function},
      ],
      [
        {'label': 'MC', 'value': 'MC', 'type': ButtonType.memory},
        {'label': 'MR', 'value': 'MR', 'type': ButtonType.memory},
        {'label': 'M+', 'value': 'M+', 'type': ButtonType.memory},
        {'label': 'M−', 'value': 'M-', 'type': ButtonType.memory},
        {'label': 'π', 'value': 'π', 'type': ButtonType.function},
        {
          'label': 'Mode\n${_angleMode.label}',
          'value': 'MODE',
          'type': ButtonType.utility,
        },
      ],
    ];
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
          IconButton(
            icon: Icon(
              widget.themeMode == CalculatorThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            tooltip: 'Switch Theme',
            onPressed: widget.onToggleTheme,
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
                child: GridView.count(
                  crossAxisCount: 6,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.1,
                  children: [
                    for (final row in _buttonGrid)
                      for (final btn in row)
                        CalculatorButton(
                          label: btn['label'],
                          onTap: () => _onButtonPressed(btn['value']),
                          type: btn['type'],
                          theme: theme,
                          isShift: btn['value'] == 'SHIFT'
                              ? isShiftActive
                              : false,
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
