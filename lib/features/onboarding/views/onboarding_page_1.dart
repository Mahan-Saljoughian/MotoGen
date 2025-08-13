import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/core/constants/app_images.dart';

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 150.h),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  width: 250.w,
                  height: 60.h,
                  child: Text(
                    "“موتوژن” یه همراه هوشمند برای مراقبت از خودروی شما!",
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
                    "با این اپلیکیشن، مدیریت سرویس‌ها و رسیدگی‌های دوره‌ای خودرو ساده‌تر از همیشه انجام می‌شه. همه اطلاعات مهم همیشه در دسترس شماست تا با خیال راحت رانندگی کنید.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blue400,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                SizedBox(height: 116.h),

                Image.asset(
                  AppImages.firstOnboardingImage,
                  width: 300.w,
                  height: 157.h,
                ),

                SizedBox(height: 87.h),

                Padding(
                  padding: EdgeInsets.only(right: 280.w),
                  child: GestureDetector(
                    onTap: () {
                     Navigator.pushReplacementNamed(context, '/onboardingPage2');

                    },

                    child: Container(
                      width: 48,
                      height: 48,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.orange600,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: SvgPicture.asset(AppIcons.arrowLeft),
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
