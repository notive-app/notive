import 'package:flutter/material.dart';

class CustomSliderThumbCircle extends SliderComponentShape {
  final double thumbRadius;
  final int min;
  final int max;
  final String unit;
  final int val;
  final bool dist;

  const CustomSliderThumbCircle({
    @required this.thumbRadius,
    this.min = 0,
    this.max = 10,
    this.unit = "",
    this.val,
    this.dist,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
  }) {
    final Canvas canvas = context.canvas;

    if (dist) {
      String convertedVal = (val / 1000).toStringAsFixed(1);
      final paint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      TextSpan span = new TextSpan(
        style: new TextStyle(
          fontSize: thumbRadius * .4,
          fontWeight: FontWeight.w700,
          color: sliderTheme.thumbColor,
        ),
        text: convertedVal + unit,
      );

      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      tp.layout();
      Offset textCenter =
          Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2));

      canvas.drawCircle(center, thumbRadius * .9, paint);
      tp.paint(canvas, textCenter);
    } else {
      String convertedVal = (val / 60).toStringAsFixed(1);
      final paint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      TextSpan span = new TextSpan(
        style: new TextStyle(
          fontSize: thumbRadius * .5,
          fontWeight: FontWeight.w700,
          color: sliderTheme.thumbColor,
        ),
        text: convertedVal + unit,
      );

      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      tp.layout();
      Offset textCenter =
          Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2));

      canvas.drawCircle(center, thumbRadius * .9, paint);
      tp.paint(canvas, textCenter);
    }
  }

  String getValue(double value) {
    return ((value).round()).toString();
  }
}
