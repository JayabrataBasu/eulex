import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import '../../services/angle_mode.dart';

class GraphFunction {
  GraphFunction({required this.expression, required this.color});
  final String expression; // raw user expression using x
  final Color color;
}

class GraphingState extends ChangeNotifier {
  final List<GraphFunction> _functions = [];
  // Viewport center and scale (logical units)
  double _xmin = -10, _xmax = 10, _ymin = -10, _ymax = 10;
  AngleMode angleMode = AngleMode.rad; // independent of scientific for now

  List<GraphFunction> get functions => List.unmodifiable(_functions);
  double get xmin => _xmin;
  double get xmax => _xmax;
  double get ymin => _ymin;
  double get ymax => _ymax;

  void addFunction(String expr) {
    if (expr.trim().isEmpty) return;
    final color = Colors.primaries[_functions.length % Colors.primaries.length];
    _functions.add(GraphFunction(expression: expr.trim(), color: color));
    notifyListeners();
  }

  void removeFunction(GraphFunction f) {
    _functions.remove(f);
    notifyListeners();
  }

  void clear() {
    _functions.clear();
    notifyListeners();
  }

  void zoom(double factor) {
    // factor <1 zoom in, >1 zoom out
    final cx = (_xmin + _xmax) / 2;
    final cy = (_ymin + _ymax) / 2;
    final w = (_xmax - _xmin) * factor;
    final h = (_ymax - _ymin) * factor;
    _xmin = cx - w / 2;
    _xmax = cx + w / 2;
    _ymin = cy - h / 2;
    _ymax = cy + h / 2;
    notifyListeners();
  }

  void pan(double dx, double dy) {
    _xmin += dx;
    _xmax += dx;
    _ymin += dy;
    _ymax += dy;
    notifyListeners();
  }

  // Sample each function to produce points.
  List<Offset> sample(GraphFunction f, {int samples = 400}) {
    final List<Offset> pts = [];
    final parser = ShuntingYardParser();
    Expression? exp;
    try {
      exp = parser.parse(f.expression.replaceAll('^', '^'));
    } catch (_) {
      return pts;
    }
    final cm = ContextModel();
    for (int i = 0; i < samples; i++) {
      final x = _xmin + (_xmax - _xmin) * i / (samples - 1);
      try {
        cm.bindVariableName('x', Number(x));
        final y = exp.evaluate(EvaluationType.REAL, cm);
        if (y.isFinite) {
          pts.add(Offset(x, y));
        }
      } catch (_) {
        // skip point
      }
    }
    return pts;
  }
}
