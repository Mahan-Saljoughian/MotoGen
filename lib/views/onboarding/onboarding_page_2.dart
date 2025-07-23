import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/views/onboarding/onboarding_indicator.dart';
import 'package:motogen/views/onboarding/personal_info_screen.dart';
import 'package:motogen/views/widgets/onboarding_button.dart';

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 150),

          child: Center(
            child: Column(
              children: [
                Container(
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

                Container(
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
                  "assets/images/Need technical inspection.png",
                  width: 370.w,
                  height: 370.h,
                ),

                onboardingButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OnboardingIndicator(),
                      ),
                    );
                  },
                  text: "َشروع",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
