import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';

class CarItem extends StatelessWidget {
  const CarItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),

      decoration: BoxDecoration(
        border: Border.all(color: AppColors.blue200),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          SvgPicture.asset(AppIcons.car, width: 33.w, height: 33.w),
          SizedBox(width: 16.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "چنگیز خان",
                style: TextStyle(
                  color: AppColors.blue800,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                "پژو 206 تیپ 5",
                style: TextStyle(
                  color: AppColors.blue800,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(width: 180.w),
          SvgPicture.asset(AppIcons.edit, width: 24.w, height: 24.h),
        ],
      ),
    );
  }
}
