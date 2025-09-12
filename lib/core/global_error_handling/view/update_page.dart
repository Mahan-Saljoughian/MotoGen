import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/core/constants/app_images.dart';
import 'package:motogen/features/onboarding/widgets/onboarding_button.dart';

class UpdatePage extends StatelessWidget {
  final String updateUrl;
  const UpdatePage({super.key, required this.updateUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue50,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            Image.asset(AppImages.update),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Text(
              "این نسخه از موتوژن دیگه پشتیبانی\n نمیشه!\n برای استفاده از برنامه بروزرسانی کنید.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.blue500,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.17),
            OnboardingButton(text: "بروزرسانی"),
          ],
        ),
      ),
    );
  }
}
