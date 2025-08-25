enum AngleMode { deg, rad, grad }

extension AngleModeLabel on AngleMode {
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
}
