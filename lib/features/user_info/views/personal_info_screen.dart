import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/features/user_info/viewmodels/personal_info_controller_view_model.dart';
import 'package:motogen/features/onboarding/widgets/dot_indicator.dart';
import 'package:motogen/widgets/field_text.dart';
import 'package:motogen/features/onboarding/widgets/onboarding_button.dart';
import 'package:motogen/widgets/my_app_bar.dart';

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
      resizeToAvoidBottomInset:
          false, // keep button in place when keyboard opens
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Center(
            child: Column(
              children: [
                // Title row
                MyAppBar(titleText: "مشخصات فردی"),

                SizedBox(height: 90.h),

                // Form fields
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
                    ],
                  ),
                ),

                // Bottom section
                SizedBox(height: MediaQuery.of(context).size.height * 0.48.h),

                DotIndicator(currentPage: currentPage, count: count),
                SizedBox(height: 24.h),
                OnboardingButton(currentPage: currentPage, onPressed: onNext),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
