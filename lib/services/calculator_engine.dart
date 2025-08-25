// lib/services/calculator_engine.dart
import 'dart:math' as math;
import 'package:math_expressions/math_expressions.dart';
import 'angle_mode.dart';

class CalculatorEngine {
  // Balanced function replacement (generic)
  String _processFunctions(
    String expr,
    List<String> names,
    String Function(String name, String arg) builder,
  ) {
    final nameSet = names.toSet();
    final sb = StringBuffer();
    int i = 0;
    while (i < expr.length) {
      bool matched = false;
      for (final name in nameSet) {
        if (i + name.length < expr.length &&
            expr.startsWith(name, i) &&
            (i == 0 || !RegExp(r'[A-Za-z0-9_]').hasMatch(expr[i - 1]))) {
          int k = i + name.length;
          while (k < expr.length && expr[k] == ' ') {
            k++;
          }
          if (k < expr.length && expr[k] == '(') {
            int depth = 0;
            int j = k;
            while (j < expr.length) {
              final c = expr[j];
              if (c == '(') depth++;
              if (c == ')') {
                depth--;
                if (depth == 0) {
                  final arg = expr.substring(k + 1, j);
                  sb.write(builder(name, arg));
                  i = j + 1;
                  matched = true;
                  break;
                }
              }
              j++;
            }
          }
          if (matched) break;
        }
      }
      if (!matched) {
        sb.writeCharCode(expr.codeUnitAt(i));
        i++;
      }
    }
    return sb.toString();
  }

  // Prepare expression: symbol normalization + advanced replacements
  String _prepareExpression(String input) {
    // 1. CRITICAL: Standardize the input to lowercase first.
    String expr = input.toLowerCase();

    expr = expr.replaceAll(RegExp(r'\s+'), '');

    // Basic symbol replacements
    expr = expr
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('－', '-')
        .replaceAll('＋', '+')
        .replaceAll('√(', 'sqrt(')
        .replaceAll('³√(', 'cbrt(')
        .replaceAll('π', 'pi')
        .replaceAll('log₁₀(', 'log(');

    // UI aliases (REMOVE wrong arcsin/arccos/arctan usage)
    expr = expr
        .replaceAll('sinh⁻¹', 'asinh')
        .replaceAll('cosh⁻¹', 'acosh')
        .replaceAll('tanh⁻¹', 'atanh');

    expr = expr
        .replaceAll('sin⁻¹(', 'asin(')
        .replaceAll('cos⁻¹(', 'acos(')
        .replaceAll('tan⁻¹(', 'atan(');

    // Superscript quick mappings (common buttons)
    expr = expr
        .replaceAll('⁻¹', '^-1') // Now this is safe to run
        .replaceAll('²', '^2')
        .replaceAll('³', '^3');

    // Generic superscript digit sequence (e.g. ⁴⁵) -> ^45
    expr = expr.replaceAllMapped(
      RegExp(r'([0-9A-Za-z\)])([⁰¹²³⁴⁵⁶⁷⁸⁹]+)'),
      (m) => '${m[1]}^${_superscriptDigitsToNormal(m[2]!)}',
    );

    // Standalone leading superscripts (edge) -> ^digits (optional)
    expr = expr.replaceAllMapped(
      RegExp(r'^([⁰¹²³⁴⁵⁶⁷⁸⁹]+)'),
      (m) => '^${_superscriptDigitsToNormal(m[1]!)}',
    );

    // Factorial normalization (keep existing)
    final factPattern = RegExp(r'((?:\d+|\([^()]*\)))!');
    while (factPattern.hasMatch(expr)) {
      expr = expr.replaceAllMapped(factPattern, (m) => 'fact(${m[1]})');
    }

    // Combinatorics tokens
    expr = expr.replaceAll('nPr', 'P').replaceAll('nCr', 'C');

    // Expand permutations
    final permPattern = RegExp(r'P\(\s*([^,()]+)\s*,\s*([^,()]+)\s*\)');
    expr = expr.replaceAllMapped(
      permPattern,
      (m) => '(fact(${m[1]})/fact((${m[1]})-(${m[2]})))',
    );

    // Expand combinations
    final combPattern = RegExp(r'C\(\s*([^,()]+)\s*,\s*([^,()]+)\s*\)');
    expr = expr.replaceAllMapped(
      combPattern,
      (m) => '(fact(${m[1]})/(fact(${m[2]})*fact((${m[1]})-(${m[2]}))))',
    );

    // mod(a,b)
    final modPattern = RegExp(r'mod\(\s*([^,()]+)\s*,\s*([^,()]+)\s*\)');
    expr = expr.replaceAllMapped(
      modPattern,
      (m) => '((${m[1]})-floor((${m[1]})/(${m[2]}))*(${m[2]}))',
    );

    // cbrt(x) -> (x)^(1/3)  (simple arg)
    expr = expr.replaceAllMapped(
      RegExp(r'cbrt\(([^()]+)\)'),
      (m) => '((${m[1]})^(1/3))',
    );

    expr = _expandHyperbolicInverses(expr);
    // SHIFT functions support: cot & acot (if provided by UI)
    expr = _processFunctions(expr, ['cot'], (n, arg) => '(1/tan(($arg)))');
    expr = _processFunctions(expr, [
      'acot',
    ], (n, arg) => '((pi/2)-atan(($arg)))');
    expr = _inlineLiteralGcdLcm(expr);
    return expr;
  }

  String _superscriptDigitsToNormal(String s) {
    const map = {
      '⁰': '0',
      '¹': '1',
      '²': '2',
      '³': '3',
      '⁴': '4',
      '⁵': '5',
      '⁶': '6',
      '⁷': '7',
      '⁸': '8',
      '⁹': '9',
    };
    return s.split('').map((c) => map[c] ?? '').join();
  }

  String _expandHyperbolicInverses(String expr) {
    // Use balanced scanning with builder
    expr = _processFunctions(expr, ['asinh', 'acosh', 'atanh'], (name, arg) {
      switch (name) {
        case 'asinh':
          return '(ln(($arg)+sqrt(($arg)^2+1)))';
        case 'acosh':
          return '(ln(($arg)+sqrt(($arg)-1)*sqrt(($arg)+1)))';
        case 'atanh':
          return '((1/2)*ln((1+($arg))/(1-($arg))))';
        default:
          return '$name($arg)';
      }
    });
    return expr;
  }

  String _inlineLiteralGcdLcm(String expr) {
    int gcd(int a, int b) {
      a = a.abs();
      b = b.abs();
      while (b != 0) {
        final t = b;
        b = a % b;
        a = t;
      }
      return a;
    }

    int lcm(int a, int b) {
      if (a == 0 || b == 0) return 0;
      return (a ~/ gcd(a, b)) * b;
    }

    final gcdPattern = RegExp(r'gcd\(\s*(-?\d+)\s*,\s*(-?\d+)\s*\)');
    expr = expr.replaceAllMapped(gcdPattern, (m) {
      final a = int.parse(m[1]!);
      final b = int.parse(m[2]!);
      return gcd(a, b).toString();
    });

    final lcmPattern = RegExp(r'lcm\(\s*(-?\d+)\s*,\s*(-?\d+)\s*\)');
    expr = expr.replaceAllMapped(lcmPattern, (m) {
      final a = int.parse(m[1]!);
      final b = int.parse(m[2]!);
      return lcm(a, b).toString();
    });

    return expr;
  }

  // Runtime gcd/lcm for non-literal arguments (balanced parsing)
  String _resolveRuntimeGcdLcm(String expr, AngleMode mode) {
    expr = _resolveRuntimeFunction(expr, 'gcd', (a, b) {
      final av = _evalSub(a, mode);
      final bv = _evalSub(b, mode);
      int ai = av.round();
      int bi = bv.round();
      while (bi != 0) {
        final t = bi;
        bi = ai % bi;
        ai = t;
      }
      return ai.toDouble();
    });
    expr = _resolveRuntimeFunction(expr, 'lcm', (a, b) {
      final av = _evalSub(a, mode);
      final bv = _evalSub(b, mode);
      int ai = av.round();
      int bi = bv.round();
      if (ai == 0 || bi == 0) return 0.0;
      int g;
      int x = ai.abs(), y = bi.abs();
      while (y != 0) {
        final t = y;
        y = x % y;
        x = t;
      }
      g = x;
      return (ai ~/ g * bi).toDouble();
    });
    return expr;
  }

  String _resolveRuntimeFunction(
    String expr,
    String name,
    double Function(String a, String b) compute,
  ) {
    while (true) {
      final idx = expr.indexOf('$name(');
      if (idx == -1) break;
      final startArgs = idx + name.length + 1;
      int depth = 1;
      int i = startArgs;
      while (i < expr.length && depth > 0) {
        if (expr[i] == '(')
          depth++;
        else if (expr[i] == ')')
          depth--;
        i++;
      }
      if (depth != 0) break; // unbalanced
      final inside = expr.substring(startArgs, i - 1);
      final commaIndex = _findTopLevelComma(inside);
      if (commaIndex == -1) {
        // malformed; skip
        break;
      }
      final arg1 = inside.substring(0, commaIndex);
      final arg2 = inside.substring(commaIndex + 1);
      final value = compute(arg1, arg2);
      expr = expr.substring(0, idx) + value.toString() + expr.substring(i);
    }
    return expr;
  }

  int _findTopLevelComma(String s) {
    int depth = 0;
    for (int i = 0; i < s.length; i++) {
      final c = s[i];
      if (c == '(')
        depth++;
      else if (c == ')')
        depth--;
      else if (c == ',' && depth == 0)
        return i;
    }
    return -1;
  }

  double _evalSub(String sub, AngleMode mode) {
    // Core evaluation without secondary runtime gcd/lcm pass to avoid loops (no vars)
    final resultStr = _evaluateCore(sub, mode, const {}, skipRuntime: true);
    return double.tryParse(resultStr) ?? double.nan;
  }

  // Angle mode processing
  String _applyAngleMode(String expr, AngleMode mode) {
    if (mode == AngleMode.rad) return expr;

    // Direct trig (sin cos tan)
    expr = _processFunctions(expr, [
      'sin',
      'cos',
      'tan',
    ], (name, arg) => '$name(($arg)*${_angleFactor(mode)})');

    // Inverse trig (asin acos atan) scale result
    expr = _processFunctions(expr, [
      'asin',
      'acos',
      'atan',
    ], (name, arg) => '(($name($arg))*${_inverseFactor(mode)})');

    // acot replacement produced earlier uses atan inside; scaling already handled.

    return expr;
  }

  String _angleFactor(AngleMode mode) {
    switch (mode) {
      case AngleMode.deg:
        return '(pi/180)';
      case AngleMode.grad:
        return '(pi/200)';
      case AngleMode.rad:
        return '1';
    }
  }

  String _inverseFactor(AngleMode mode) {
    switch (mode) {
      case AngleMode.deg:
        return '(180/pi)';
      case AngleMode.grad:
        return '(200/pi)';
      case AngleMode.rad:
        return '1';
    }
  }

  String evaluate(
    String input,
    AngleMode angleMode, [
    Map<String, double>? variables,
  ]) {
    return _evaluateCore(input, angleMode, variables ?? const {});
  }

  String _evaluateCore(
    String input,
    AngleMode angleMode,
    Map<String, double> variables, {
    bool skipRuntime = false,
  }) {
    if (input.trim().isEmpty) return '0';
    try {
      // --- START OF DEBUG BLOCK ---
      print("-----------");
      print("STAGE 1: RAW INPUT -> '$input'");

      String expr = _prepareExpression(input);
      print("STAGE 2: AFTER PREPARE -> '$expr'");

      expr = _applyAngleMode(expr, angleMode);
      print("STAGE 3: AFTER ANGLE MODE -> '$expr'");

      if (!skipRuntime) {
        expr = _resolveRuntimeGcdLcm(expr, angleMode);
        print("STAGE 4: AFTER RUNTIME GCD/LCM -> '$expr'");
      }

      print("FINAL: PASSING TO PARSER -> '$expr'");
      print("-----------");
      // --- END OF DEBUG BLOCK ---

      // UPDATED: use ShuntingYardParser (Parser deprecated)
      final parser = ShuntingYardParser();
      final parsed = parser.parse(expr);
      final cm = ContextModel();
      // Bind constants
      cm.bindVariable(Variable('pi'), Number(math.pi));
      cm.bindVariable(Variable('e'), Number(math.e));
      // Bind user variables (case-insensitive -> lowercase)
      variables.forEach((name, value) {
        cm.bindVariable(Variable(name.toLowerCase()), Number(value));
      });
      final value = parsed.evaluate(EvaluationType.REAL, cm);
      if (value.isNaN || value.isInfinite) return 'Error';
      final intVal = value.toInt();
      return (value == intVal)
          ? intVal.toString()
          : _trimTrailingZeros(value.toString());
    } catch (e) {
      // Also print the actual error to see what the parser is complaining about
      print("CAUGHT PARSER ERROR: $e");
      return 'Error';
    }
  }

  String _trimTrailingZeros(String s) {
    if (!s.contains('.')) return s;
    s = s.replaceFirst(RegExp(r'0+$'), '');
    s = s.replaceFirst(RegExp(r'\.$'), '');
    return s;
  }
}
