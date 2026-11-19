extension DoubleRounding on double {
  /// Rounds normally to 2 decimal places and returns a double.
  double toTwoDecimalRound() {
    return double.parse(toStringAsFixed(2));
  }
}
