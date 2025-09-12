import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_images.dart';
import 'package:motogen/core/global_error_handling/app_with_container.dart';
import 'package:motogen/core/global_error_handling/view/update_page.dart';
import 'package:motogen/features/onboarding/views/onboarding_internet.dart';
import 'package:motogen/features/onboarding/widgets/onboarding_button.dart';

class GlobalErrorScreen extends StatelessWidget {
  final String error;
  final bool isForceUpdate;
  final String? updateUrl;

  const GlobalErrorScreen({
    super.key,
    required this.error,
    this.isForceUpdate = false,
    this.updateUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (isForceUpdate) {
      // --- UpdatePage layout ---
      return UpdatePage(updateUrl: updateUrl!);
    }
    if (error == 'socket_exception') {
      return const OnboardingInternet(); // <-- Your page
    }
    // --- Generic error layout ---
    return Scaffold(
      backgroundColor: AppColors.blue50,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.17),
              Image.asset(AppImages.error),
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              Text(
                "مشکلی در اجرای برنامه به وجود اومده!\n لطفا برنامه رو ببند و دوباره باز کن.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blue500,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                error,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blue500,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),

              //SizedBox(height: MediaQuery.of(context).size.height * 0.19),
              OnboardingButton(
                text: "بستن برنامه",
                enabled: true,
                onPressed: () => SystemNavigator.pop(),
              ),

              /*    ElevatedButton(
                onPressed: () {
                  AppWithContainer.of(context)?.restart();
                },
                child: const Text("ریستارت برنامه"),
              ) */
            ],
          ),
        ),
      ),
    );
  }
}
