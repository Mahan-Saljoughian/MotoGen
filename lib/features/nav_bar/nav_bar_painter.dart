import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';

class NavBarPainter extends CustomPainter {
  final double x;
  final bool isRTL;
  final bool debugSegments; // Toggle this to show/hide segment colors

  NavBarPainter(this.x, this.isRTL, {this.debugSegments = false});

  // Height values
  final double height = 80.0.h;
  final double start = 40.0.h;
  final double end = 120.0.h;
  final double paddingHorizental = 25.0.w;

  @override
  void paint(Canvas canvas, Size size) {
    // Use responsive units if using ScreenUtil:
    final double leftEdge = paddingHorizental;
    final double rightEdge = size.width - paddingHorizental;

    // Cup width & depth
    final double cupWidth = 140.w;
    final double cupDepth = 34.h;

    double xPainted = x;
    if (isRTL) {
      xPainted = size.width - (x + cupWidth);
    }

    final double cupStartX = xPainted;
    final double cupEndX = xPainted + cupWidth;

    // ---- MAIN SHAPE PATH ----
    final path = Path();
    path.moveTo(0.0, start + 40.h);
    // Top-left arc
    path.quadraticBezierTo(0.0, start, leftEdge, start);
    if (cupStartX > leftEdge) {
      path.lineTo(cupStartX + 0.15.w * cupWidth, start);
    }
    // Cup left shoulder
    path.quadraticBezierTo(
      cupStartX + 0.27.w * cupWidth,
      start,
      cupStartX + 0.3.w * cupWidth,
      start + 17.h,
    );
    // Cup left dip curve
    path.quadraticBezierTo(
      cupStartX + 0.35.w * cupWidth,
      start + cupDepth,
      cupStartX + 0.5.w * cupWidth,
      start + cupDepth,
    );
    // Cup right dip curve
    path.quadraticBezierTo(
      cupEndX - 0.35.w * cupWidth,
      start + cupDepth,
      cupEndX - 0.3.w * cupWidth,
      start + 17.h,
    );
    // Cup right shoulder
    path.quadraticBezierTo(
      cupEndX - 0.27.w * cupWidth,
      start,
      cupEndX - 0.15.w * cupWidth,
      start,
    );

    if (cupEndX < rightEdge) {
      path.lineTo(rightEdge, start);
    }

    // Top-right arc
    path.quadraticBezierTo(size.width, start, size.width, start + 40.h);
    // Right vertical
    path.lineTo(size.width, end - 40.h);
    // Bottom-right arc
    path.quadraticBezierTo(size.width, end, rightEdge, end);
    // Bottom line
    path.lineTo(leftEdge, end);
    // Bottom-left arc
    path.quadraticBezierTo(0.0, end, 0.0, end - 40.h);
    // Left vertical
    path.lineTo(0.0, start + 40.h);
    path.close();

    // --- DEBUG: OVERLAY SEGMENTS COLORED ---
    if (debugSegments) {
      // 1. Top-left arc
      Path seg1 = Path()
        ..moveTo(0.0, start + 40.h)
        ..quadraticBezierTo(0.0, start, leftEdge, start);
      canvas.drawPath(
        seg1,
        Paint()
          ..color = Colors.red
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke,
      );

      // 2. Line to cup
      if (cupStartX > leftEdge) {
        Path seg2 = Path()
          ..moveTo(leftEdge, start)
          ..lineTo(cupStartX + 0.15.w * cupWidth, start);
        canvas.drawPath(
          seg2,
          Paint()
            ..color = Colors.orange
            ..strokeWidth = 5
            ..style = PaintingStyle.stroke,
        );
      }

      // 3. Cup left shoulder
      Path seg3 = Path()
        ..moveTo(cupStartX + 0.3.w * cupWidth, start + 17.h)
        ..quadraticBezierTo(
          cupStartX + 0.27.w * cupWidth,
          start,
          cupStartX + 0.15.w * cupWidth,
          start,
        );
      canvas.drawPath(
        seg3,
        Paint()
          ..color = Colors.purpleAccent
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke,
      );

      // 4. Cup left dip
      Path seg4 = Path()
        ..moveTo(cupStartX + 0.3.w * cupWidth, start + 17.h)
        ..quadraticBezierTo(
          cupStartX + 0.35.w * cupWidth,
          start + cupDepth,
          cupStartX + 0.5.w * cupWidth,
          start + cupDepth,
        );
      canvas.drawPath(
        seg4,
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke,
      );

      // 5. Cup right dip
      Path seg5 = Path()
        ..moveTo(cupStartX + 0.5.w * cupWidth, start + cupDepth)
        ..quadraticBezierTo(
          cupEndX - 0.35.w * cupWidth,
          start + cupDepth,
          cupEndX - 0.3.w * cupWidth,
          start + 17.h,
        );
      canvas.drawPath(
        seg5,
        Paint()
          ..color = Colors.green
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke,
      );

      // 6. Cup right shoulder
      Path seg6 = Path()
        ..moveTo(cupEndX - 0.3.w * cupWidth, start + 17.h)
        ..quadraticBezierTo(
          cupEndX - 0.27.w * cupWidth,
          start,
          cupEndX - 0.15.w * cupWidth,
          start,
        );
      canvas.drawPath(
        seg6,
        Paint()
          ..color = Colors.amber
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke,
      );

      // 7. Line to rightEdge
      Path seg7 = Path()
        ..moveTo(cupEndX - 0.15.w * cupWidth, start)
        ..lineTo(rightEdge - 5.w, start);
      canvas.drawPath(
        seg7,
        Paint()
          ..color = Colors.cyan
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke,
      );

      // 8. Top-right arc
      Path seg8 = Path()
        ..moveTo(rightEdge, start)
        ..quadraticBezierTo(size.width, start, size.width, start + 40.h);
      canvas.drawPath(
        seg8,
        Paint()
          ..color = Colors.deepPurple
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke,
      );

      // 9. Right vertical
      Path seg9 = Path()
        ..moveTo(size.width, start + 40.h)
        ..lineTo(size.width, end - 40.h);
      canvas.drawPath(
        seg9,
        Paint()
          ..color = Colors.teal
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke,
      );

      // 10. Bottom-right arc
      Path seg10 = Path()
        ..moveTo(size.width, end - 40.h)
        ..quadraticBezierTo(size.width, end, rightEdge, end);
      canvas.drawPath(
        seg10,
        Paint()
          ..color = Colors.blueGrey
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke,
      );

      // 11. Bottom line
      Path seg11 = Path()
        ..moveTo(rightEdge, end)
        ..lineTo(leftEdge, end);
      canvas.drawPath(
        seg11,
        Paint()
          ..color = Colors.lime
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke,
      );

      // 12. Bottom-left arc
      Path seg12 = Path()
        ..moveTo(leftEdge, end)
        ..quadraticBezierTo(0.0, end, 0.0, end - 40.h);
      canvas.drawPath(
        seg12,
        Paint()
          ..color = Colors.pink
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke,
      );

      // 13. Left vertical up
      Path seg13 = Path()
        ..moveTo(0.0, end - 40.h)
        ..lineTo(0.0, start + 40.h);
      canvas.drawPath(
        seg13,
        Paint()
          ..color = Colors.brown
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke,
      );
    }

    // ---- SHADOW & FILL SHAPE ----
    canvas.drawShadow(path, const Color(0x3F626A7D), 10.0, true);
    final fillPaint = Paint()
      ..color = AppColors.white50
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // ---- CUP CIRCLE (FAB zone) ----
    canvas.drawCircle(
      Offset(xPainted + 70.w, 40.h), // center position (keep as before)
      27.r, // radius
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
