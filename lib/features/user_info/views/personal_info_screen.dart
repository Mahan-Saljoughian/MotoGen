import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/features/user_info/viewmodels/personal_info_controller_view_model.dart';
import 'package:motogen/features/onboarding/widgets/dot_indicator.dart';
import 'package:motogen/widgets/field_text.dart';
import 'package:motogen/features/onboarding/widgets/onboarding_button.dart';

class PersonalInfoScreen extends ConsumerWidget {
  final int currentPage;
  final int count;
  final VoidCallback onNext;
  final VoidCallback onBack;
  const PersonalInfoScreen({
    super.key,
    required this.currentPage,
    required this.count,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalInfoViewModel = ref.watch(personalInfoProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 20.w),

                    SizedBox(width: 110.w),
                    Text(
                      "مشخصات فردی",
                      style: TextStyle(
                        color: AppColors.blue500,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 120.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Column(
                    children: [
                      FieldText(
                        controller: personalInfoViewModel.nameController,
                        isValid: personalInfoViewModel.isNameValid,
                        labelText: "نام",
                        hintText: "علی",
                       
                        error: personalInfoViewModel.errorName,
                      ),

                      FieldText(
                        controller: personalInfoViewModel.lastNameController,
                        isValid: personalInfoViewModel.isLastNameValid,
                        labelText: "نام خانوادگی",
                        hintText: "علیزاده",
                        
                        error: personalInfoViewModel.errorLastName,
                      ),

                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.42,
                      ),

                      DotIndicator(currentPage: currentPage, count: count),
                      SizedBox(height: 24.h),
                      OnboardingButton(
                        currentPage: currentPage,
                        onPressed: onNext,
                      ),
                    ],
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
