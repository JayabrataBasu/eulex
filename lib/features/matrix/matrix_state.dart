import 'package:flutter/material.dart';
import 'package:ml_linalg/matrix.dart';

enum MatrixTab { a, b, result }

enum MatrixOperation { add, subtract, multiply, det, transpose, inverse }

class MatrixState extends ChangeNotifier {
  int rowsA = 2, colsA = 2;
  int rowsB = 2, colsB = 2;
  List<List<double>> dataA = List.generate(2, (_) => List.filled(2, 0));
  List<List<double>> dataB = List.generate(2, (_) => List.filled(2, 0));
  Matrix? result;
  String? error;
  MatrixTab currentTab = MatrixTab.a;

  void setDimensionsA(int r, int c) {
    rowsA = r;
    colsA = c;
    dataA = List.generate(r, (_) => List.filled(c, 0));
    notifyListeners();
  }

  void setDimensionsB(int r, int c) {
    rowsB = r;
    colsB = c;
    dataB = List.generate(r, (_) => List.filled(c, 0));
    notifyListeners();
  }

  void updateCellA(int r, int c, String v) {
    final d = double.tryParse(v) ?? 0;
    dataA[r][c] = d;
  }

  void updateCellB(int r, int c, String v) {
    final d = double.tryParse(v) ?? 0;
    dataB[r][c] = d;
  }

  void setTab(MatrixTab tab) {
    currentTab = tab;
    notifyListeners();
  }

  void perform(MatrixOperation op) {
    error = null;
    try {
      final A = Matrix.fromList(dataA);
      final B = Matrix.fromList(dataB);
      switch (op) {
        case MatrixOperation.add:
          if (rowsA != rowsB || colsA != colsB) {
            throw Exception('Matrix dimensions must match for addition');
          }
          result = A + B;
          break;
        case MatrixOperation.subtract:
          if (rowsA != rowsB || colsA != colsB) {
            throw Exception('Matrix dimensions must match for subtraction');
          }
          result = A - B;
          break;
        case MatrixOperation.multiply:
          if (colsA != rowsB) {
            throw Exception(
              'Columns of A must equal rows of B for multiplication',
            );
          }
          result = A * B;
          break;
        case MatrixOperation.det:
          final target = currentTab == MatrixTab.a ? A : B;
          final r = currentTab == MatrixTab.a ? rowsA : rowsB;
          final c = currentTab == MatrixTab.a ? colsA : colsB;
          if (r != c) throw Exception('Matrix must be square for determinant');
          final detVal = _determinant(
            target.toList().map((row) => row.toList()).toList(),
          );
          result = Matrix.fromList([
            [detVal],
          ]);
          break;
        case MatrixOperation.transpose:
          result = (currentTab == MatrixTab.a ? A : B).transpose();
          break;
        case MatrixOperation.inverse:
          final target = currentTab == MatrixTab.a ? A : B;
          if (target.rowsNum != target.columnsNum) {
            throw Exception('Matrix must be square for inverse');
          }
          final inv = _inverse(
            target.toList().map((row) => row.toList()).toList(),
          );
          if (inv == null) throw Exception('Matrix is singular');
          result = Matrix.fromList(inv);
          break;
      }
      currentTab = MatrixTab.result;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    }
    notifyListeners();
  }
}

double _determinant(List<List<double>> m) {
  final n = m.length;
  if (n == 1) return m[0][0];
  if (n == 2) return m[0][0] * m[1][1] - m[0][1] * m[1][0];
  double det = 0;
  for (int c = 0; c < n; c++) {
    det += (c % 2 == 0 ? 1 : -1) * m[0][c] * _determinant(_minor(m, 0, c));
  }
  return det;
}

List<List<double>> _minor(List<List<double>> m, int r, int c) {
  return [
    for (int i = 0; i < m.length; i++)
      if (i != r)
        [
          for (int j = 0; j < m.length; j++)
            if (j != c) m[i][j],
        ],
  ];
}

List<List<double>>? _inverse(List<List<double>> m) {
  final n = m.length;
  // augment with identity
  List<List<double>> aug = [
    for (int i = 0; i < n; i++)
      [...m[i], ...List.generate(n, (j) => i == j ? 1.0 : 0.0)],
  ];
  for (int col = 0; col < n; col++) {
    // find pivot
    int pivot = col;
    for (int r = col; r < n; r++) {
      if (aug[r][col].abs() > aug[pivot][col].abs()) pivot = r;
    }
    if (aug[pivot][col].abs() < 1e-12) return null; // singular
    if (pivot != col) {
      final tmp = aug[pivot];
      aug[pivot] = aug[col];
      aug[col] = tmp;
    }
    final pivotVal = aug[col][col];
    for (int j = 0; j < 2 * n; j++) aug[col][j] /= pivotVal;
    for (int r = 0; r < n; r++)
      if (r != col) {
        final factor = aug[r][col];
        for (int j = 0; j < 2 * n; j++) aug[r][j] -= factor * aug[col][j];
      }
  }
  return [
    for (int i = 0; i < n; i++) [for (int j = 0; j < n; j++) aug[i][j + n]],
  ];
}
