
class FeetAndInches {
  final int? feet;
  final double? inches;

  const FeetAndInches({required this.feet, required this.inches});

  @override
  String toString() => "$feet' ${inches?.toStringAsFixed(1)}\"";
}

FeetAndInches cmToFeetAndInches(double? cm, {int decimals = 1}) {
  if(cm == null) {
    return FeetAndInches(feet: null, inches: null);
  }
  final totalInches = cm / 2.54;
  int feet = totalInches ~/ 12;

  final factor = _pow10(decimals);
  double inches = (totalInches % 12 * factor).round() / factor;

  // Handle carry-over when inches rounds up to 12.0
  if (inches >= 12.0) {
    feet += 1;
    inches = 0.0;
  }

  return FeetAndInches(feet: feet, inches: inches);
}

double _pow10(int exp) {
  double result = 1.0;
  for (int i = 0; i < exp; i++) {
    result *= 10.0;
  }
  return result;
}