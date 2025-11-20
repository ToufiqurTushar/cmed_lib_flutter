import 'package:flutter/material.dart';

class HexColor extends Color {
  // Constructor for HexColor with null safety
  HexColor(final String hex) : super(_getColorFromHex(hex));

  // Helper function to convert hex string to int with null safety
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor; // Add FF if no opacity is provided
    }
    return int.parse(hexColor, radix: 16); // Parse the hex string to an integer
  }
}
