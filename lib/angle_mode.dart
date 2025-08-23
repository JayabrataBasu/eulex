enum AngleMode { deg, rad, grad }

extension AngleModeExtension on AngleMode {
  String get label {
    switch (this) {
      case AngleMode.deg:
        return 'DEG';
      case AngleMode.rad:
        return 'RAD';
      case AngleMode.grad:
        return 'GRAD';
    }
  }

  /// Converts [value] (in this mode) to radians.
  double toRadians(double value) {
    switch (this) {
      case AngleMode.deg:
        return value * (3.141592653589793 / 180.0);
      case AngleMode.rad:
        return value;
      case AngleMode.grad:
        return value * (3.141592653589793 / 200.0);
    }
  }
}
