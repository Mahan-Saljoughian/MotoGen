import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/viewmodels/personal_info_view_model.dart';

class PersonalInfoScreen extends ConsumerWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalInfoViewModel = ref.watch(personalInfoProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
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
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      TextField(
                        controller: personalInfoViewModel.nameController,
                        decoration: InputDecoration(
                          labelText: "نام",
                          labelStyle: TextStyle(
                            color: personalInfoViewModel.isNameValid
                                ? AppColors.blue500
                                : Color(0xFFC60B0B),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              width: 1.5.w,
                              color: personalInfoViewModel.isNameValid
                                  ? AppColors.blue500
                                  : Color(0xFFC60B0B),
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              width: 1.5,
                              color: personalInfoViewModel.isNameValid
                                  ? AppColors.blue500
                                  : Color(0xFFC60B0B),
                            ),
                          ),

                          hintText: "علی",
                          hintStyle: TextStyle(
                            color: AppColors.black100,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          contentPadding: EdgeInsets.only(right: 24),
                        ),
                      ),

                      SizedBox(height: 42.h),

                      TextField(
                        controller: personalInfoViewModel.lastNameController,
                        decoration: InputDecoration(
                          labelText: "نام خانوادگی",
                          labelStyle: TextStyle(
                            color: personalInfoViewModel.isLastNameValid
                                ? AppColors.blue500
                                : Color(0xFFC60B0B),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),

                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              width: 1.5.w,
                              color: personalInfoViewModel.isLastNameValid
                                  ? AppColors.blue500
                                  : Color(0xFFC60B0B),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              width: 1.5.w,
                              color: personalInfoViewModel.isLastNameValid
                                  ? AppColors.blue500
                                  : Color(0xFFC60B0B),
                            ),
                          ),
                          hintText: "علیزاده",
                          hintStyle: TextStyle(
                            color: AppColors.black100,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          contentPadding: EdgeInsets.only(right: 24.w),
                        ),
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
