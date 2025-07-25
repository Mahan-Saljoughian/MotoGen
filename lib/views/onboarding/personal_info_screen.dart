import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/viewmodels/personal_info_controller_view_model.dart';
import 'package:motogen/views/widgets/field_text.dart';

class PersonalInfoScreen extends ConsumerWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalInfoViewModel = ref.watch(personalInfoProvider);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(vertical: 20.h),
          child: Center(
            child: Column(
              children: [
                Text(
                  "مشخصات فردی",
                  style: TextStyle(
                    color: AppColors.blue500,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 120.h),

                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 40.w),
                  child: Column(
                    children: [
                      FieldText(
                        controller: personalInfoViewModel.nameController,
                        isValid: personalInfoViewModel.isNameValid,
                        labelText: "نام",
                        hintText: "علی",
                      ),

                      SizedBox(height: 42.h),

                      FieldText(
                        controller: personalInfoViewModel.lastNameController,
                        isValid: personalInfoViewModel.isLastNameValid,
                        labelText: "نام خانوادگی",
                        hintText: "علیزاده",
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
