import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'calculator_button.dart';
import 'calculator_engine.dart';
import 'theme.dart';

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
      _themeMode = CalculatorThemeMode.values[
          (_themeMode.index + 1) % CalculatorThemeMode.values.length];
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
  String _expression = '';
  String _result = '';
  List<String> _history = [];
  double? _memory;

  final List<String> _buttons = [
    '7',
    '8',
    '9',
    '/',
    'sin',
    '4',
    '5',
    '6',
    '*',
    'cos',
    '1',
    '2',
    '3',
    '-',
    'tan',
    '0',
    '.',
    '=',
    '+',
    '√',
    '(',
    ')',
    'C',
    'M+',
    'M-',
    'MR',
    'MC'
  ];

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _expression = '';
        _result = '';
      } else if (value == '=') {
        _result = CalculatorEngine.evaluate(_expression);
        if (_result != 'Error') {
          _history.insert(0, '$_expression = $_result');
          if (_history.length > 15) _history.removeLast();
        }
      } else if (value == 'M+') {
        if (_result.isNotEmpty) _memory = double.tryParse(_result);
      } else if (value == 'M-') {
        _memory = null;
      } else if (value == 'MR') {
        if (_memory != null) _expression += _memory!.toString();
      } else if (value == 'MC') {
        _memory = null;
      } else if (value == 'sin' || value == 'cos' || value == 'tan') {
        _expression += '$value(';
      } else {
        _expression += value;
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
            icon: Icon(
              widget.themeMode == CalculatorThemeMode.dark
                  ? Icons.light_mode
                  : widget.themeMode == CalculatorThemeMode.light
                      ? Icons.palette
                      : Icons.dark_mode,
            ),
            tooltip: 'Switch Theme',
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 380, maxHeight: 650),
          decoration: BoxDecoration(
            color: theme.themeData.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        _expression,
                        style: TextStyle(
                          fontSize: 28,
                          color: theme.buttonTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _result,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: theme.operatorTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Buttons
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: _buttons.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    childAspectRatio: 0.95, // Adjusted for better fit
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    final btn = _buttons[index];
                    final isOperator = '/x*-+=sincostanlog√'.contains(btn);
                    return CalculatorButton(
                      label: btn,
                      onTap: () => _onButtonPressed(btn),
                      isOperator: isOperator,
                      backgroundColor: isOperator
                          ? widget.theme.operatorButtonBackground
                          : widget.theme.buttonBackground,
                      textColor: isOperator
                          ? widget.theme.operatorTextColor
                          : widget.theme.buttonTextColor,
                    );
                  },
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
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    child: Text(
                      _history[idx],
                      style: TextStyle(
                          fontSize: 16,
                          color: theme.buttonTextColor.withOpacity(0.7)),
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