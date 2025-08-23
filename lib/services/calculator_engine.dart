import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;
import 'angle_mode.dart';

class SyntaxError implements Exception {
  final String message;
  SyntaxError([this.message = "Syntax Error"]);
  @override
  String toString() => message;
}

class MathError implements Exception {
  final String message;
  MathError([this.message = "Math Error"]);
  @override
  String toString() => message;
}

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

      // Add inverse trig and hyperbolic function replacements
      exp = _replaceInverseTrigFunctions(exp);
      exp = _replaceHyperbolicFunctions(exp);

      Parser p = Parser();
      ContextModel cm = ContextModel();
      Expression expParsed;
      try {
        expParsed = p.parse(exp);
      } catch (e) {
        throw SyntaxError("Invalid expression syntax.");
      }
      double eval;
      try {
        eval = expParsed.evaluate(EvaluationType.REAL, cm);
      } catch (e) {
        throw MathError("Invalid mathematical operation.");
      }
      if (eval.isNaN || eval.isInfinite) {
        return double.nan.toString();
      }
      _lastResult = eval.toString();
      return _lastResult;
    } on SyntaxError catch (_) {
      return double.nan.toString();
    } on MathError catch (_) {
      return double.nan.toString();
    } catch (e) {
      // Catch any other math-related errors (e.g., domain errors)
      return double.nan.toString();
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

  static String _replaceInverseTrigFunctions(String exp) {
    exp = exp.replaceAllMapped(RegExp(r'asin\(([^)]+)\)'), (m) {
      final arg = double.tryParse(_evaluateSimple(m[1]!)) ?? 0.0;
      double radians = math.asin(arg);
      double result;
      switch (_angleMode) {
        case AngleMode.deg:
          result = radians * (180.0 / math.pi);
          break;
        case AngleMode.rad:
          result = radians;
          break;
        case AngleMode.grad:
          result = radians * (200.0 / math.pi);
          break;
      }
      return result.toString();
    });
    exp = exp.replaceAllMapped(RegExp(r'acos\(([^)]+)\)'), (m) {
      final arg = double.tryParse(_evaluateSimple(m[1]!)) ?? 0.0;
      double radians = math.acos(arg);
      double result;
      switch (_angleMode) {
        case AngleMode.deg:
          result = radians * (180.0 / math.pi);
          break;
        case AngleMode.rad:
          result = radians;
          break;
        case AngleMode.grad:
          result = radians * (200.0 / math.pi);
          break;
      }
      return result.toString();
    });
    exp = exp.replaceAllMapped(RegExp(r'atan\(([^)]+)\)'), (m) {
      final arg = double.tryParse(_evaluateSimple(m[1]!)) ?? 0.0;
      double radians = math.atan(arg);
      double result;
      switch (_angleMode) {
        case AngleMode.deg:
          result = radians * (180.0 / math.pi);
          break;
        case AngleMode.rad:
          result = radians;
          break;
        case AngleMode.grad:
          result = radians * (200.0 / math.pi);
          break;
      }
      return result.toString();
    });
    return exp;
  }

  static String _replaceHyperbolicFunctions(String exp) {
    exp = exp.replaceAllMapped(RegExp(r'sinh\(([^)]+)\)'), (m) {
      final arg = double.tryParse(_evaluateSimple(m[1]!)) ?? 0.0;
      final ex = math.exp(arg);
      final eNegX = math.exp(-arg);
      return ((ex - eNegX) / 2.0).toString();
    });
    exp = exp.replaceAllMapped(RegExp(r'cosh\(([^)]+)\)'), (m) {
      final arg = double.tryParse(_evaluateSimple(m[1]!)) ?? 0.0;
      final ex = math.exp(arg);
      final eNegX = math.exp(-arg);
      return ((ex + eNegX) / 2.0).toString();
    });
    exp = exp.replaceAllMapped(RegExp(r'tanh\(([^)]+)\)'), (m) {
      final arg = double.tryParse(_evaluateSimple(m[1]!)) ?? 0.0;
      final ex = math.exp(arg);
      final eNegX = math.exp(-arg);
      final numerator = ex - eNegX;
      final denominator = ex + eNegX;
      if (denominator == 0) return '0';
      return (numerator / denominator).toString();
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

  static double differentiate(String expression, double point) {
    // Use central difference: f'(x) ≈ (f(x+h) - f(x-h)) / (2h)
    const double h = 1e-5;
    try {
      String exprPlus = expression.replaceAll('x', '(${point + h})');
      String exprMinus = expression.replaceAll('x', '(${point - h})');
      double fPlus = double.tryParse(evaluate(exprPlus)) ?? double.nan;
      double fMinus = double.tryParse(evaluate(exprMinus)) ?? double.nan;
      if (fPlus.isNaN || fMinus.isNaN) return double.nan;
      return (fPlus - fMinus) / (2 * h);
    } catch (e) {
      return double.nan;
    }
  }
}
