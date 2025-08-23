import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;
import 'angle_mode.dart';

class CalculatorEngine {
  static double _memory = 0.0;
  static AngleMode _angleMode = AngleMode.deg;
  static String _lastResult = '0';

  static void setAngleMode(AngleMode mode) {
    _angleMode = mode;
  }

  static AngleMode get angleMode => _angleMode;

  static String get lastResult => _lastResult;

  static String evaluate(String expression) {
    try {
      String exp = expression
          .replaceAll('÷', '/')
          .replaceAll('×', '*')
          .replaceAll('−', '-')
          .replaceAll('√', 'sqrt')
          .replaceAll('π', math.pi.toString())
          .replaceAll('Ans', _lastResult)
          .replaceAll('EXP', 'E')
          .replaceAll('x²', '^2')
          .replaceAll('xʸ', '^')
          .replaceAll('log', 'log')
          .replaceAll('ln', 'ln');

      exp = _replaceTrigFunctions(exp);

      Parser p = Parser();
      ContextModel cm = ContextModel();
      Expression expParsed = p.parse(exp);
      double eval = expParsed.evaluate(EvaluationType.REAL, cm);
      _lastResult = eval.toString();
      return _lastResult;
    } catch (e) {
      return 'Error';
    }
  }

  static String _replaceTrigFunctions(String exp) {
    exp = exp.replaceAllMapped(RegExp(r'sin\(([^)]+)\)'), (m) {
      final arg = double.tryParse(_evaluateSimple(m[1]!)) ?? 0.0;
      final radians = _angleMode.toRadians(arg);
      return math.sin(radians).toString();
    });
    exp = exp.replaceAllMapped(RegExp(r'cos\(([^)]+)\)'), (m) {
      final arg = double.tryParse(_evaluateSimple(m[1]!)) ?? 0.0;
      final radians = _angleMode.toRadians(arg);
      return math.cos(radians).toString();
    });
    exp = exp.replaceAllMapped(RegExp(r'tan\(([^)]+)\)'), (m) {
      final arg = double.tryParse(_evaluateSimple(m[1]!)) ?? 0.0;
      final radians = _angleMode.toRadians(arg);
      return math.tan(radians).toString();
    });
    return exp;
  }

  static String _evaluateSimple(String expr) {
    try {
      Parser p = Parser();
      ContextModel cm = ContextModel();
      Expression expParsed = p.parse(expr);
      double eval = expParsed.evaluate(EvaluationType.REAL, cm);
      return eval.toString();
    } catch (_) {
      return '0';
    }
  }

  static void memoryClear() {
    _memory = 0.0;
  }

  static String memoryRecall() {
    return _memory.toString();
  }

  static void memoryAdd(String value) {
    final v = double.tryParse(value);
    if (v != null) _memory += v;
  }

  static void memorySubtract(String value) {
    final v = double.tryParse(value);
    if (v != null) _memory -= v;
  }

  static bool hasMemory() => _memory != 0.0;
}
