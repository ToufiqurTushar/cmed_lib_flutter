import 'package:flutter/material.dart';
Widget CMEDBottomButton({
  required String label,
  required VoidCallback? onPressed,
  Color? backgroundColor,
  Color? textColor,
  BuildContext? context,
}) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor??(context!=null?Theme.of(context).primaryColor:Colors.lightBlue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26.0),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor??Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}