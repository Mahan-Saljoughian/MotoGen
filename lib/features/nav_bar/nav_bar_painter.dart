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

  @override
  void paint(Canvas canvas, Size size) {
    double xPainted = x;
    if (isRTL) {
      xPainted = size.width - (x + 140.w); // 140.w: width of your dip path
    }
    Path path = Path();
    path.moveTo(0.0, start);

    path.lineTo(xPainted < 20.w ? 20.w : xPainted, start);
    path.quadraticBezierTo(
      20.w + xPainted,
      start,
      30.w + xPainted,
      start + 15.h,
    ); //4th start from left
    path.quadraticBezierTo(
      40.w + xPainted,
      start + 32.h,
      70.w + xPainted,
      start + 35.h,
    ); //2nd the left curve , 4th conorls the middle of the deep
    path.quadraticBezierTo(
      100.w + xPainted,
      start + 32.h,
      110.w + xPainted,
      start + 15.h,
    ); //2nd the right curve , 4th start from right
    path.quadraticBezierTo(
      120.w + xPainted,
      start,
      (140.w + xPainted) > (size.width - 20.w)
          ? (size.width - 20.w)
          : 140.w + xPainted,
      start,
    );
    path.lineTo(size.width - 20.w, start);

    path.quadraticBezierTo(size.width, start, size.width, start + 25.h);
    path.lineTo(size.width, end - 25.h);
    path.quadraticBezierTo(size.width, end, size.width - 25.w, end);
    path.lineTo(25.w, end);
    path.quadraticBezierTo(0.0, end, 0.0, end - 25.h);
    path.lineTo(0.0, start + 25.h);
    path.quadraticBezierTo(0.0, start, 20.w, start);
    path.close();

    canvas.drawShadow(
      path,
      const Color(0x3F626A7D), // Your shadow color
      10.r, // Blur radius, make responsive as you wish
      true, // true closes the path for a proper shadow
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
