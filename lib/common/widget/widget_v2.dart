import 'package:flutter/material.dart';


Widget GradientWhiteToPrimary({required Widget child}) {
  return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.white,
            Colors.white,
            Color(0xFFDEFAE7),
            Color(0xFFDEFAE7),
            Color(0xFFDEFAE7),
            Color(0xFFDEFAE7),
          ],
        ),
      ),
      child: child
  );
}
