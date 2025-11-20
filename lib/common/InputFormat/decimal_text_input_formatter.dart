import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;
  final double maxValue;

  DecimalTextInputFormatter({
    this.decimalRange = 2,
    this.maxValue = 100000000,
  }) : assert(decimalRange >= 0);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final text = newValue.text;

    if (text.isEmpty) {
      return newValue;
    }

    // Regex: only digits and up to `decimalRange` digits after decimal
    final regEx = RegExp(r'^\d*\.?\d{0,' + decimalRange.toString() + r'}$');

    if (regEx.hasMatch(text)) {
      // Check numeric value
      try {
        final value = double.parse(text);
        if (value <= maxValue) {
          return newValue; // valid within limit
        }
      } catch (_) {
        // parsing failed (e.g. just ".")
      }
    }

    return oldValue; // reject invalid input
  }
}
