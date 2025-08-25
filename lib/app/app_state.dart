// lib/app/app_state.dart

import 'package:flutter/material.dart';
import '../services/calculator_engine.dart';
import '../services/angle_mode.dart'; // NEW: shared angle mode
import 'theme.dart';

enum ShiftState { normal, shift, alpha }

enum OperationMode { none, storing }

class CalculatorState extends ChangeNotifier {
  final CalculatorEngine _engine = CalculatorEngine();
  final TextEditingController _controller = TextEditingController(text: '0');
  ShiftState _shiftState = ShiftState.normal;
  // Angle mode state
  AngleMode _angleMode = AngleMode.deg;
  OperationMode _operationMode = OperationMode.none;
  final Map<String, double> _variables = {'m': 0.0};
  int _currentThemeIndex = 0;

  ShiftState get shiftState => _shiftState;
  String get input => _controller.text;
  TextEditingController get controller => _controller;
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
    final result = _engine.evaluate(_controller.text, _angleMode, _variables);
    _controller.text = result;
    _controller.selection = TextSelection.collapsed(
      offset: _controller.text.length,
    );
    notifyListeners();
  }

  void setShiftState(ShiftState newState) {
    _shiftState = (_shiftState == newState) ? ShiftState.normal : newState;
    notifyListeners();
  }

  void appendInput(String value) {
    _insertAtCursor(value, replaceZero: true);
  }

  void handleFunctionInput(String value) {
    // If in store mode and value is single-letter variable name, store
    if (_operationMode == OperationMode.storing && value.length == 1) {
      storeVariable(value);
      return;
    }
    if (_controller.text == '0' && value != '.') {
      _controller.text = value;
      _controller.selection = TextSelection.collapsed(offset: value.length);
    } else {
      _insertAtCursor(value);
    }
    _shiftState = ShiftState.normal;
    notifyListeners();
  }

  void backspace() {
    final text = _controller.text;
    final sel = _controller.selection;
    int pos = sel.baseOffset;
    if (pos < 0) pos = text.length;
    if (text.isEmpty) return;
    if (pos > 0) {
      final newText = text.substring(0, pos - 1) + text.substring(pos);
      _controller.text = newText.isEmpty ? '0' : newText;
      final newPos = (pos - 1).clamp(0, _controller.text.length);
      _controller.selection = TextSelection.collapsed(offset: newPos);
    } else if (text.length > 1) {
      // delete last char if cursor at start
      final newText = text.substring(1);
      _controller.text = newText.isEmpty ? '0' : newText;
      _controller.selection = const TextSelection.collapsed(offset: 0);
    } else {
      _controller.text = '0';
      _controller.selection = const TextSelection.collapsed(offset: 1);
    }
    notifyListeners();
  }

  void allClear() {
    _controller.text = '0';
    _controller.selection = const TextSelection.collapsed(offset: 1);
    _shiftState = ShiftState.normal;
    notifyListeners();
  }

  // Variable memory system
  void activateStoreMode() {
    _operationMode = OperationMode.storing;
    notifyListeners();
  }

  void storeVariable(String name) {
    final evalResult = _engine.evaluate(
      _controller.text,
      _angleMode,
      _variables,
    );
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
      if (_controller.text == '0') {
        _controller.text = v.toString();
        _controller.selection = TextSelection.collapsed(
          offset: _controller.text.length,
        );
      } else {
        _insertAtCursor(v.toString());
      }
      notifyListeners();
    }
  }

  // Theme
  void cycleTheme() {
    _currentThemeIndex = (_currentThemeIndex + 1) % CalculatorThemes.all.length;
    notifyListeners();
  }

  // Cursor movement
  void moveCursor(int delta) {
    int pos = _controller.selection.baseOffset;
    if (pos < 0) pos = _controller.text.length; // if none, go to end first
    final newPos = (pos + delta).clamp(0, _controller.text.length);
    _controller.selection = TextSelection.collapsed(offset: newPos);
    notifyListeners();
  }

  void _insertAtCursor(String value, {bool replaceZero = false}) {
    final text = _controller.text;
    final sel = _controller.selection;
    int start = sel.start;
    int end = sel.end;
    if (start < 0 || end < 0) {
      start = end = text.length;
    }
    String newText;
    if (replaceZero &&
        text == '0' &&
        start == text.length &&
        end == text.length &&
        value != '.') {
      newText = value;
      start = 0;
      end = 1; // after insert we set selection to length
    } else {
      newText = text.replaceRange(start, end, value);
      start = start + value.length;
    }
    _controller.text = newText;
    _controller.selection = TextSelection.collapsed(
      offset: start.clamp(0, _controller.text.length),
    );
  }
}
