import 'package:math_expressions/math_expressions.dart';

class CalculatorEngine {
  static String evaluate(String expression) {
    try {
      String exp = expression
          .replaceAll('√', 'sqrt')
          .replaceAll('sin', 'sin')
          .replaceAll('cos', 'cos')
          .replaceAll('tan', 'tan')
          .replaceAll('log', 'log');
      Parser p = Parser();
      Expression expParsed = p.parse(exp);
      ContextModel cm = ContextModel();
      double eval = expParsed.evaluate(EvaluationType.REAL, cm);
      return eval.toString();
    } catch (e) {
      return 'Error';
    }
  }
}
