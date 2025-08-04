import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';

class MoreBottomSheet extends StatelessWidget {
  const MoreBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 235.h,
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 13.h, horizontal: 44.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  SvgPicture.asset(AppIcons.setting, width: 24.w, height: 24.h),
                  SizedBox(width: 10.w),
                  Text(
                    "تنظیمات",
                    style: TextStyle(
                      color: AppColors.blue600,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  SvgPicture.asset(AppIcons.crown, width: 24.w, height: 24.h),
                  SizedBox(width: 10.w),
                  Text(
                    "اشتراک",
                    style: TextStyle(
                      color: AppColors.blue600,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  SvgPicture.asset(AppIcons.logout, width: 24.w, height: 24.h),
                  SizedBox(width: 10.w),
                  Text(
                    "خروج از حساب",
                    style: TextStyle(
                      color: Color(0xFFC60B0B),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
