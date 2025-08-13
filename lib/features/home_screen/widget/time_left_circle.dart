import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TimeLeftCircle extends StatelessWidget {
  final int daysLeft;
  final int totalDays;
  final String serviceTitle;
  const TimeLeftCircle({
    super.key,
    required this.daysLeft,
    required this.totalDays,
    required this.serviceTitle,
  });

  @override
  Widget build(BuildContext context) {
    double percent = daysLeft / totalDays;
    Color getSlideColor() {
      if (percent <= 0.2) return Color(0xFFCD3A3A);
      if (percent <= 0.4) return AppColors.orange500;
      return Color(0xFF3C9452);
    }

    Color getBackGroundColor() {
      if (percent <= 0.2) return Color(0xFFFBEAEA);
      if (percent <= 0.4) return AppColors.orange50;
      return Color(0xFFDEF9E5);
    }

    final slideColor = getSlideColor();
    final backGroundColor = getBackGroundColor();
    return InnerShadow(
      shadows: [
        BoxShadow(
          blurRadius: 5,
          offset: Offset(0, 0),
          color: Colors.black.withAlpha(50),
        ),
      ],
      child: Container(
        width: 100.w,
        height: 100.h,

        decoration: BoxDecoration(
          color: Colors.white.withAlpha(153),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: CircularPercentIndicator(
          radius: 34.r,
          lineWidth: 8.w,
          percent: percent,
          center: Text(
            "$daysLeft\nروز",
            style: TextStyle(
              color: slideColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          progressColor: slideColor,
          backgroundColor: backGroundColor,
          circularStrokeCap: CircularStrokeCap.round,
          footer: Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: Text(
              serviceTitle,
              style: TextStyle(
                color: AppColors.blue500,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
