import 'package:flutter/material.dart';

class SleepChartPainter extends CustomPainter {
  final double lightBlueStageStart;
  final double lightBlueStageEnd;
  final double blueStageEnd;
  final double lightBlueRemStageEnd;
  final double greenStageEnd;
  final Color lightBlueColor;
  final Color blueColor;
  final Color lightBlueRemColor;
  final Color greenColor;
  final Color backgroundColor;
  final double borderWidth;
  final Color borderColor;
  final String title;

  SleepChartPainter({
    required this.lightBlueStageStart,
    required this.lightBlueStageEnd,
    required this.blueStageEnd,
    required this.lightBlueRemStageEnd,
    required this.greenStageEnd,
    this.lightBlueColor = Colors.lightBlue,
    this.blueColor = Colors.blue,
    this.lightBlueRemColor = Colors.lightBlue,
    this.greenColor = Colors.green,
    this.backgroundColor = Colors.white,
    this.borderWidth = 2.0,
    this.borderColor = Colors.grey,
    this.title = 'Sleep Chart',
  });

  @override
  void paint(Canvas canvas, Size size) {
    final stage1Rect = Rect.fromLTRB(
      size.width * 0,
      0,
      size.width * lightBlueStageEnd,
      size.height,
    );

    final stage2Rect = Rect.fromLTRB(
      size.width * lightBlueStageEnd,
      0,
      size.width * blueStageEnd,
      size.height,
    );

    final stage3Rect = Rect.fromLTRB(
      size.width * blueStageEnd,
      0,
      size.width * lightBlueRemStageEnd,
      size.height,
    );

    final stage4Rect = Rect.fromLTRB(
      size.width * lightBlueRemStageEnd,
      0,
      size.width * greenStageEnd,
      size.height,
    );

    final backgroundPaint = Paint()..color = backgroundColor;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    final stage1Paint = Paint()..color = lightBlueColor;
    canvas.drawRect(stage1Rect, stage1Paint);

    final stage2Paint = Paint()..color = blueColor;
    canvas.drawRect(stage2Rect, stage2Paint);

    final stage3Paint = Paint()..color = lightBlueRemColor;
    canvas.drawRect(stage3Rect, stage3Paint);

    final stage4Paint = Paint()..color = greenColor;
    canvas.drawRect(stage4Rect, stage4Paint);

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), borderPaint);

    final textStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    final textSpan = TextSpan(text: title, style: textStyle);

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final xCenter = (size.width / 2) - (textPainter.width / 2);
    final yCenter = (size.height / 2) - (textPainter.height / 2);

    textPainter.paint(canvas, Offset(xCenter, yCenter));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
