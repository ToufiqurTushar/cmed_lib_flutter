import 'dart:math';
extension DoubleRounding on double {
  /// Rounds normally to 2 decimal places and returns a double.
  double roundDouble(int places) {
    num mod = pow(10.0, places);
    return (this * mod).round() / mod;
  }
}
