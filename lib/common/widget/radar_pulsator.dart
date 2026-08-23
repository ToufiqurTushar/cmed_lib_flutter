import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CenterRadar extends StatelessWidget {
  int? oneFullRotationInMilliSeconds;
  String? info;
  CenterRadar({this.oneFullRotationInMilliSeconds, this.info, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadarPulsator(
            oneFullRotationInMilliSeconds: oneFullRotationInMilliSeconds??2000,
            color: Theme.of(context).primaryColor,
            centerWidget: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(22.0),
              child: SvgPicture.asset(
                "assets/icons-v2/bluetooth.svg",
                colorFilter: ColorFilter.mode(
                  Theme.of(context).primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          if(info != null)
            Text(
              info!,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            )
        ],
      ),
    );
  }
}

class RadarPulsator extends StatefulWidget {
  final Widget centerWidget;
  final Color? color;
  int? oneFullRotationInMilliSeconds;
  final int defaultOneFullRotationInMilliSeconds;
  RadarPulsator({super.key, this.oneFullRotationInMilliSeconds,this.defaultOneFullRotationInMilliSeconds = 6000, required this.centerWidget, this.color});

  @override
  State<RadarPulsator> createState() => _RadarPulsatorState();
}

class _RadarPulsatorState extends State<RadarPulsator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.oneFullRotationInMilliSeconds??widget.defaultOneFullRotationInMilliSeconds!),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radarColor = widget.color ?? Theme.of(context).primaryColor;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final angle = _controller.value * 2 * pi - pi / 2;
        return Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size(280, 280),
              painter: RadarPainter(angle, radarColor),
            ),
            widget.centerWidget,
          ],
        );
      },
    );
  }
}

class RadarPainter extends CustomPainter {
  final double angle;
  final Color color;

  RadarPainter(this.angle, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw concentric circles matching design
    final circlePaint = Paint()
      ..color = color.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, radius, circlePaint);
    canvas.drawCircle(center, radius * 0.75, circlePaint);
    canvas.drawCircle(center, radius * 0.50, circlePaint);
    canvas.drawCircle(center, radius * 0.25, circlePaint);
    canvas.drawCircle(center, radius * 0.01, circlePaint);

    // Draw sweep sector (conic gradient)
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        colors: [
          color.withOpacity(0.0),
          color.withOpacity(0.0),
          color.withOpacity(0.12),
        ],
        stops: const [0.0, 0.75, 1.0],
        transform: GradientRotation(angle),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, sweepPaint);

    // Draw the main sweep line
    final linePaint = Paint()
      ..color = color.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final lineEnd = Offset(
      center.dx + radius * cos(angle),
      center.dy + radius * sin(angle),
    );
    canvas.drawLine(center, lineEnd, linePaint);
  }

  @override
  bool shouldRepaint(covariant RadarPainter oldDelegate) {
    return oldDelegate.angle != angle || oldDelegate.color != color;
  }
}


