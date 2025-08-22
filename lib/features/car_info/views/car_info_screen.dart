import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/features/car_info/models/car_form_state_item.dart';
import 'package:motogen/features/car_info/viewmodels/car_state_notifier.dart';
import 'package:motogen/features/bottom_sheet/config/car_info_field_config.dart';
import 'package:motogen/features/bottom_sheet/widgets/build_form_fields.dart';
import 'package:motogen/features/onboarding/widgets/dot_indicator.dart';
import 'package:motogen/features/onboarding/widgets/onboarding_button.dart';

class CarInfoScreen extends ConsumerWidget {
  final int currentPage;
  final int count;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final List<CarInfoFieldConfig<CarFormStateItem>> carInfoField;
  const CarInfoScreen({
    super.key,
    required this.currentPage,
    required this.count,
    required this.onNext,
    required this.onBack,
    required this.carInfoField,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
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

                    SizedBox(width: 100.w),

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

                SizedBox(height: 120.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: BuildFormFields<CarFormStateItem>(
                    provider: carStateNotifierProvider.select(
                      (carState) => carState.currentCar!,
                    ),
                    fieldsBuilder: (state, ref) => carInfoField,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.20.h),

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
