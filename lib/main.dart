import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'calculator_button.dart';
import 'calculator_engine.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eulex Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});
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
      } else {
        _expression += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      appBar: AppBar(
        title: const Text('Eulex Calculator'),
        backgroundColor: const Color(0xFF22252D),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 380, maxHeight: 650),
          decoration: BoxDecoration(
            color: const Color(0xFF22252D),
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
                  color: const Color(0xFF292D36),
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
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _result,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                    childAspectRatio: 1.1,
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
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              // History
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF181A20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  reverse: true,
                  itemCount: _history.length,
                  itemBuilder: (context, idx) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    child: Text(
                      _history[idx],
                      style: const TextStyle(fontSize: 16, color: Colors.white54),
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