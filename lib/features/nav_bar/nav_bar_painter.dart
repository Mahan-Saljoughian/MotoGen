import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';

class NavBarPainter extends CustomPainter {
  double x;
  final bool isRTL;

  NavBarPainter(this.x, this.isRTL);

  double height = 80.h;
  double start = 40.h;
  double end = 120.h;
  double paddingHorizental = 25.w;

  @override
  void paint(Canvas canvas, Size size) {
    final double leftEdge = paddingHorizental;
    final double rightEdge = size.width - paddingHorizental;

    // Cup width & depth
    final double cupWidth = 140.w; // width of dip/cup, adjust to taste
    final double cupDepth = 34.h; // makes the dip deeper/shallower
    ;

    double minCupX = leftEdge;
    double maxCupX = rightEdge - cupWidth;
    double xPainted = x;
    if (isRTL) {
      xPainted = size.width - (x + cupWidth); // 140.w: width of your dip path
    }

    //xPainted = xPainted.clamp(minCupX, maxCupX);

    final double cupStartX = xPainted;
    final double cupEndX = xPainted + cupWidth;

    Path path = Path();
    path.moveTo(0.0, start + 40.h);
    path.quadraticBezierTo(0.0, start, leftEdge, start);

    if (cupStartX > leftEdge) {
      path.lineTo(cupStartX, start); // Only draws if cup offset in from edge
    }

    // Cup/dip curves (can tweak control points for organic look)
    path.quadraticBezierTo(
      cupStartX + 0.27 * cupWidth,
      start, // control
      cupStartX + 0.3 * cupWidth,
      start + 17.h, // left shoulder
    );
    path.quadraticBezierTo(
      cupStartX + 0.35 * cupWidth,
      start + cupDepth, // control (left dip)
      cupStartX + 0.5 * cupWidth,
      start + cupDepth, // bottom
    );
    path.quadraticBezierTo(
      cupEndX - 0.35 * cupWidth,
      start + cupDepth, // control (right dip)
      cupEndX - 0.3 * cupWidth,
      start + 17.h, // right shoulder
    );
    path.quadraticBezierTo(
      cupEndX - 0.27 * cupWidth,
      start, // control
      cupEndX - 0.15 * cupWidth,
      start, // dip ends
    );

    // Top-right straight line
    path.lineTo(rightEdge, start);

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

    // Top-left arc
    path.quadraticBezierTo(0.0, start, leftEdge, start);

    path.close();

    canvas.drawShadow(
      path,
      const Color(0x3F626A7D), 
      10.r, 
      true, 
    );
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);

    canvas.drawCircle(Offset(xPainted + 70.w, 40.h), 27.r, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
