import 'package:flutter/material.dart';


class LinearLoading extends StatelessWidget {
  const LinearLoading({
    super.key,
    required this.isVisible,
    this.color,
  });

  final Color? color;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2,
      child: Visibility(
        visible: isVisible,
        child: LinearProgressIndicator(
          color: Colors.white,
          minHeight: 2,
          backgroundColor: color ?? Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
