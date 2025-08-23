import 'dart:math' as math;

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

  double toRadians(double value) {
    switch (this) {
      case AngleMode.deg:
        return value * (math.pi / 180.0);
      case AngleMode.rad:
        return value;
      case AngleMode.grad:
        return value * (math.pi / 200.0);
    }
  }
}
