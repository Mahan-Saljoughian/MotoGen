import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/core/constants/app_images.dart';
import 'package:motogen/features/car_info/viewmodels/car_use_case_api.dart';
import 'package:motogen/features/car_info/viewmodels/car_state_notifier.dart';
import 'package:motogen/features/car_info/viewmodels/nick_name_validator.dart';

import 'package:motogen/features/user_info/viewmodels/personal_info_controller_view_model.dart';
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
    final personalInfocontroller = ref.watch(personalInfoProvider);
    return Stack(
      children: [
        Scaffold(
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
                      SizedBox(height: 128.h),
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
                          isShowNeededIcon: false,
                          error: nicknameValidator.error,
                        ),
                      ),

                      Image.asset(
                        AppImages.nickNameCarPage,
                        width: 260.w,
                        height: 260.w,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 60.h,
          right: 43.w,
          child: Column(
            children: [
              DotIndicator(currentPage: currentPage, count: count),
              SizedBox(height: 24.h),
              OnboardingButton(
                currentPage: currentPage,
                onPressed: () async {
                  try {
                    await ref
                        .read(carStateNotifierProvider.notifier)
                        .completeProfile(
                          isSetNickName: true,
                          nickNametext:
                              nicknameValidator.nickNameController.text,
                          userInfo: {
                            'firstName': personalInfocontroller
                                .nameController
                                .text
                                .trim(),
                            'lastName': personalInfocontroller
                                .lastNameController
                                .text
                                .trim(),
                          },
                        );
                    onNext();
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                      Navigator.pushReplacementNamed(
                        context,
                        "/onboardingIndicator",
                      );
                    }
                  }
                },
              ),
              SizedBox(height: 20.h),
              OnboardingButton(
                pagesTitleEnum: PagesTitleEnum.skipNickName,
                onPressed: () async {
                  try {
                    await ref
                        .read(carStateNotifierProvider.notifier)
                        .completeProfile(
                          isSetNickName: false,
                          nickNametext:
                              nicknameValidator.nickNameController.text,
                          userInfo: {
                            'firstName': personalInfocontroller
                                .nameController
                                .text
                                .trim(),
                            'lastName': personalInfocontroller
                                .lastNameController
                                .text
                                .trim(),
                          },
                        );

                    onNext();
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                      Navigator.pushReplacementNamed(
                        context,
                        "/onboardingIndicator",
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
