import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

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
    'log',
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
        try {
          String exp = _expression.replaceAll('√', 'sqrt');
          Parser p = Parser();
          Expression expParsed = p.parse(exp);
          ContextModel cm = ContextModel();
          double eval = expParsed.evaluate(EvaluationType.REAL, cm);
          _result = eval.toString();
          _history.insert(0, '$_expression = $_result');
          if (_history.length > 15) _history.removeLast();
        } catch (e) {
          _result = 'Error';
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
      appBar: AppBar(
        title: const Text('Eulex Calculator'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              color: Colors.black12,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      _expression,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _result,
                    style: const TextStyle(
                        fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 1.2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final btn = _buttons[index];
                return ElevatedButton(
                  onPressed: () => _onButtonPressed(btn),
                  child: Text(btn, style: const TextStyle(fontSize: 20)),
                );
              },
            ),
          ),
          Container(
            height: 120,
            color: Colors.grey[200],
            child: ListView.builder(
              reverse: true,
              itemCount: _history.length,
              itemBuilder: (context, idx) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                child: Text(_history[idx], style: const TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
