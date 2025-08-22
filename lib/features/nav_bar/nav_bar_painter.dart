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

    // Parameters for the flat bottom in the dip
    final double flatFraction =
        0.1; // Fraction of cupWidth for the straight bottom (adjust as needed, e.g., 0.2 for ~28w flat)
    final double halfFlat = flatFraction / 2;
    final double ratio =
        1.8; // Curve control ratio from original design (large/small part)

    // Left dip fractions
    final double leftShoulderEndFrac = 0.3;
    final double leftDipEndFrac = 0.5 - halfFlat;
    final double deltaLeft = leftDipEndFrac - leftShoulderEndFrac;
    final double smallPartLeft = deltaLeft / (1 + ratio);
    final double leftControlFrac = leftShoulderEndFrac + smallPartLeft;

    // Right dip fractions
    final double rightShoulderStartFrac = 1 - 0.3; // 0.7, symmetric
    final double rightDipStartFrac = 0.5 + halfFlat;
    final double deltaRight = rightShoulderStartFrac - rightDipStartFrac;
    final double largePartRight = (ratio / (1 + ratio)) * deltaRight;
    final double rightControlFrac = rightDipStartFrac + largePartRight;

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
      cupStartX + 0.275.w * cupWidth,
      start,
      cupStartX + leftShoulderEndFrac * cupWidth,
      start + 17.h,
    );
    // Cup left dip curve (adjusted for flat bottom)
    path.quadraticBezierTo(
      cupStartX + leftControlFrac * cupWidth,
      start + cupDepth,
      cupStartX + leftDipEndFrac * cupWidth,
      start + cupDepth,
    );
    // Straight flat bottom at min dip
    path.lineTo(cupStartX + rightDipStartFrac * cupWidth, start + cupDepth);
    // Cup right dip curve (adjusted for flat bottom)
    path.quadraticBezierTo(
      cupStartX + rightControlFrac * cupWidth,
      start + cupDepth,
      cupStartX + rightShoulderStartFrac * cupWidth,
      start + 17.h,
    );
    // Cup right shoulder
    path.quadraticBezierTo(
      cupEndX - 0.275.w * cupWidth,
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
        ..moveTo(cupStartX + 0.15.w * cupWidth, start)
        ..quadraticBezierTo(
          cupStartX + 0.275.w * cupWidth,
          start,
          cupStartX + leftShoulderEndFrac * cupWidth,
          start + 17.h,
        );
      canvas.drawPath(
        seg3,
        Paint()
          ..color = Colors.purpleAccent
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke,
      );
      // 4. Cup left dip (adjusted)
      Path seg4 = Path()
        ..moveTo(cupStartX + leftShoulderEndFrac * cupWidth, start + 17.h)
        ..quadraticBezierTo(
          cupStartX + leftControlFrac * cupWidth,
          start + cupDepth,
          cupStartX + leftDipEndFrac * cupWidth,
          start + cupDepth,
        );
      canvas.drawPath(
        seg4,
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke,
      );
      // 4.5. Straight flat bottom (new segment)
      Path seg45 = Path()
        ..moveTo(cupStartX + leftDipEndFrac * cupWidth, start + cupDepth)
        ..lineTo(cupStartX + rightDipStartFrac * cupWidth, start + cupDepth);
      canvas.drawPath(
        seg45,
        Paint()
          ..color = Colors.yellow
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke,
      );
      // 5. Cup right dip (adjusted)
      Path seg5 = Path()
        ..moveTo(cupStartX + rightDipStartFrac * cupWidth, start + cupDepth)
        ..quadraticBezierTo(
          cupStartX + rightControlFrac * cupWidth,
          start + cupDepth,
          cupStartX + rightShoulderStartFrac * cupWidth,
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
        ..moveTo(cupStartX + rightShoulderStartFrac * cupWidth, start + 17.h)
        ..quadraticBezierTo(
          cupEndX - 0.275.w * cupWidth,
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
