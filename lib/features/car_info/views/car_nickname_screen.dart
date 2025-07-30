import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';

import 'package:motogen/core/constants/app_images.dart';
import 'package:motogen/features/car_info/viewmodels/car_info_form_viewmodel.dart';
import 'package:motogen/features/car_info/viewmodels/nickName_validator.dart';
import 'package:motogen/features/chat_screen/views/chat_screen.dart';
import 'package:motogen/features/phone_number/viewmodels/phone_number_controller_view_model.dart';
import 'package:motogen/features/onboarding/widgets/dot_indicator.dart';
import 'package:motogen/widgets/field_text.dart';
import 'package:motogen/features/onboarding/widgets/onboarding_button.dart';

class CarNicknameScreen extends ConsumerWidget {
  final int currentPage;
  final int count;
  final VoidCallback onNext;
  final VoidCallback onBack;
  const CarNicknameScreen({
    super.key,
    required this.currentPage,
    required this.count,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nicknameValidator = ref.watch(nickNameValidatorProvider);
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
                  Row(
                    children: [
                      SizedBox(width: 20.w),
                      GestureDetector(
                        onTap: onBack,
                        child: SvgPicture.asset(
                          AppIcons.arrowRight,
                          width: 24.w,
                          height: 24.h,
                        ),
                      ),
                      SizedBox(width: 110.w),
                      Text(
                        "مشخصات خودرو",
                        style: TextStyle(
                          color: AppColors.blue500,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 210.h),
                  Text(
                    "ماشینت رو چی صدا میکنی؟ \n لقبش رو اینجا بنویس...",
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
                      controller: nicknameValidator.nickNameController,
                      isValid: nicknameValidator.isNickNameValid,
                      labelText: "لقب",
                      hintText: "رخش",
                      error: nicknameValidator.error,
                    ),
                  ),

                

                  Image.asset(
                    AppImages.nickNameCarPage,
                    width: 260.w,
                    height: 260.w,
                  ),
                  SizedBox(height: 31.h),
                  DotIndicator(currentPage: currentPage, count: count),
                  SizedBox(height: 24.h),
                  OnboardingButton(
                    currentPage: currentPage,
                    onPressed: () {
                      ref
                          .read(carInfoFormProvider.notifier)
                          .setNickName(
                            nicknameValidator.nickNameController.text,
                          );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
