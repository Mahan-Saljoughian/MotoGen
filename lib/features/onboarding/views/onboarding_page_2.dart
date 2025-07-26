import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_images.dart';
import 'package:motogen/features/onboarding/views/onboarding_indicator.dart';

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 150.h),

          child: Center(
            child: Column(
              children: [
                SizedBox(
                  width: 270.w,
                  height: 60.h,
                  child: Text(
                    "با “موتوژن” هزینه‌های ماشینت رو مدیریت کن!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blue500,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                SizedBox(height: 98.h),

                SizedBox(
                  width: 316.w,
                  height: 84.h,
                  child: Text(
                    "با موتوژن می‌تونی خرجای ماشینتو دقیق ثبت کنی و همیشه بدونی چقدر و کجا هزینه کردی. اینطوری مدیریت ماشین آسون‌تر می‌شه و تصمیم‌هاتم حساب‌شده‌تر.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blue400,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                Image.asset(
                  AppImages.seconfOnboardingImage,
                  width: 370.w,
                  height: 370.h,
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OnboardingIndicator(),
                      ),
                    );
                  },
                  child: Container(
                    width: 330.w,
                    height: 48.w,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: AppColors.orange600,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Text(
                      "َشروع",
                      style: TextStyle(
                        color: AppColors.black50,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
