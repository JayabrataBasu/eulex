// lib/app/app_state.dart

import 'package:flutter/foundation.dart';
import '../services/calculator_engine.dart';
import '../services/angle_mode.dart'; // NEW: shared angle mode
import 'theme.dart';

enum ShiftState { normal, shift, alpha }

enum OperationMode { none, storing }

class CalculatorState extends ChangeNotifier {
  final CalculatorEngine _engine =
      CalculatorEngine(); // Create an instance of the engine
  ShiftState _shiftState = ShiftState.normal;
  String _input = "0";
  // NEW: angle mode state
  AngleMode _angleMode = AngleMode.deg;
  OperationMode _operationMode = OperationMode.none;
  final Map<String, double> _variables = {'m': 0.0};
  int _currentThemeIndex = 0;

  ShiftState get shiftState => _shiftState;
  String get input => _input;
  AngleMode get angleMode => _angleMode;
  OperationMode get operationMode => _operationMode;
  Map<String, double> get variables => Map.unmodifiable(_variables);
  CalculatorTheme get currentTheme => CalculatorThemes.all[_currentThemeIndex];

  // NEW: cycle angle mode
  void cycleAngleMode() {
    _angleMode =
        AngleMode.values[(_angleMode.index + 1) % AngleMode.values.length];
    notifyListeners();
  }

  // New method to trigger evaluation
  void evaluateExpression() {
    final result = _engine.evaluate(
      _input,
      _angleMode,
      _variables,
    ); // pass variables
    _input = result;
    notifyListeners();
  }

  void setShiftState(ShiftState newState) {
    _shiftState = (_shiftState == newState) ? ShiftState.normal : newState;
    notifyListeners();
  }

  void appendInput(String value) {
    if (_input == "0" && value != '.') {
      _input = value;
    } else {
      _input += value;
    }
    notifyListeners();
  }

  void handleFunctionInput(String value) {
    // If in store mode and value is single-letter variable name, store
    if (_operationMode == OperationMode.storing && value.length == 1) {
      storeVariable(value);
      return;
    }
    if (_input == "0") {
      _input = value;
    } else {
      _input += value;
    }
    _shiftState = ShiftState.normal;
    notifyListeners();
  }

  void backspace() {
    if (_input.length > 1) {
      _input = _input.substring(0, _input.length - 1);
    } else {
      _input = "0";
    }
    notifyListeners();
  }

  void allClear() {
    _input = "0";
    _shiftState = ShiftState.normal;
    notifyListeners();
  }

  // Variable memory system
  void activateStoreMode() {
    _operationMode = OperationMode.storing;
    notifyListeners();
  }

  void storeVariable(String name) {
    final evalResult = _engine.evaluate(_input, _angleMode, _variables);
    final v = double.tryParse(evalResult);
    if (v != null) {
      _variables[name.toLowerCase()] = v;
    }
    _operationMode = OperationMode.none;
    _shiftState = ShiftState.normal;
    notifyListeners();
  }

  void recallVariable(String name) {
    final v = _variables[name.toLowerCase()];
    if (v != null) {
      if (_input == '0') {
        _input = v.toString();
      } else {
        _input += v.toString();
      }
      notifyListeners();
    }
  }

  // Theme
  void cycleTheme() {
    _currentThemeIndex = (_currentThemeIndex + 1) % CalculatorThemes.all.length;
    notifyListeners();
  }
}
