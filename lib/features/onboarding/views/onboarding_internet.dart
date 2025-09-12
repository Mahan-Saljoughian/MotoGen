import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/core/constants/app_images.dart';

class OnboardingInternet extends StatelessWidget {
  const OnboardingInternet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue500,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.37),

            Image.asset(AppImages.logo),
            SizedBox(height: 5.h),
            Text(
              "موتوژن",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.blue50,
                fontSize: 36.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.26),

            Text(
              "لطفا وضعیت اینترنت خود را بررسی کنید.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.blue50,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 17.h),
            GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppIcons.refresh, width: 24.w, height: 24.h),
                  SizedBox(width: 7.w),
                  Text(
                    "تلاش مجدد",
                    //textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blue50,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
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
