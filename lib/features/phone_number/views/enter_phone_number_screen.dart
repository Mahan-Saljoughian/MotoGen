import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:motogen/core/constants/app_colors.dart';

import 'package:motogen/core/constants/app_images.dart';
import 'package:motogen/features/phone_number/viewmodels/phone_number_controller_view_model.dart';
import 'package:motogen/widgets/dot_indicator.dart';
import 'package:motogen/widgets/field_text.dart';
import 'package:motogen/widgets/onboarding_button.dart';

class EnterPhoneNumberScreen extends ConsumerWidget {
  final int currentPage;
  final int count;
  final VoidCallback onNext;

  const EnterPhoneNumberScreen({
    super.key,
    required this.currentPage,
    required this.count,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phoneVm = ref.watch(phoneNumberControllerProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /*  GestureDetector(
                          onTap: onBack,
                          child: SvgPicture.asset(
                            AppIcons.arrowRight,
                            width: 24.w,
                            height: 24.h,
                          ),
                        ),

                        SizedBox(width: 110.w), */
                        Text(
                          "حساب کاربری",
                          style: TextStyle(
                            color: AppColors.blue500,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 238.h),
                  Text(
                    "برای ایجاد حساب کاربری شماره موبایلت رو وارد کن...",
                    style: TextStyle(
                      color: AppColors.blue900,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: 36.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: FieldText(
                      controller: phoneVm.phoneController,
                      isValid: phoneVm.isValid,
                      labelText: "شماره موبایل",
                      hintText: "09123456789",
                    ),
                  ),

                  SizedBox(height: 25.h),

                  Image.asset(
                    AppImages.phoneNumberPageImage,
                    width: 250.w,
                    height: 250.w,
                  ),
                  SizedBox(height: 28.h),
                  DotIndicator(currentPage: currentPage, count: count),
                  SizedBox(height: 24.h),
                  OnboardingButton(currentPage: currentPage, onPressed: onNext),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
