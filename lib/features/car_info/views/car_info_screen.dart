import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/features/car_info/viewmodels/car_info_form_viewmodel.dart';

import 'package:motogen/features/car_info/config/car_info_field_config.dart';
import 'package:motogen/features/car_info/config/date_set_field_config.dart';

import 'package:motogen/features/car_info/widgets/bottomsheet_date_show.dart';
import 'package:motogen/features/car_info/widgets/bottomsheet_list_show.dart';
import 'package:motogen/features/car_info/widgets/bottomsheet_picker_field.dart';
import 'package:motogen/features/onboarding/viewmodels/personal_info_controller_view_model.dart';
import 'package:motogen/features/onboarding/widgets/dot_indicator.dart';
import 'package:motogen/features/car_info/widgets/kilometer_text_field.dart';
import 'package:motogen/features/onboarding/widgets/onboarding_button.dart';

class CarInfoScreen extends ConsumerWidget {
  final int currentPage;
  final int count;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final List<CarInfoFieldConfig> carInfoField;
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
        child: Stack(
          children: [
            SingleChildScrollView(
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
                        child: Column(
                          children: [
                            for (
                              int idx = 0;
                              idx < carInfoField.length;
                              idx++
                            ) ...[
                              Builder(
                                builder: (context) {
                                  final fieldConfig = carInfoField[idx];
                                  switch (fieldConfig.type) {
                                    case FieldInputType.picker:
                                      return Consumer(
                                        builder: (context, ref, _) {
                                          final formState = ref.watch(
                                            carInfoFormProvider,
                                          );
                                          return BottomsheetPickerField(
                                            labelText: fieldConfig
                                                .pickerConfig!
                                                .labelText,
                                            selectedText: fieldConfig
                                                .pickerConfig!
                                                .getter(formState)
                                                ?.title,
                                            onPressed: () {
                                              BottomsheetListShow.showSelectionBottomSheet(
                                                context: context,
                                                config:
                                                    fieldConfig.pickerConfig!,
                                                ref: ref,
                                                state: formState,
                                              );
                                            },
                                            errorText: fieldConfig.errorGetter
                                                ?.call(formState),
                                          );
                                        },
                                      );

                                    case FieldInputType.text:
                                      return KilometerTextField(
                                        label: fieldConfig.labelText!,
                                      );

                                    case FieldInputType.dateSetter:
                                      return Consumer(
                                        builder: (context, ref, _) {
                                          final formState = ref.watch(
                                            carInfoFormProvider,
                                          );
                                          final date = fieldConfig
                                              .dateSetFieldConfig!
                                              .getter(formState);
                                          return BottomsheetPickerField(
                                            labelText: fieldConfig
                                                .dateSetFieldConfig!
                                                .labelText,
                                            selectedText: date != null
                                                ? formatJalaliDate(date)
                                                : null,
                                            onPressed: () async {
                                              final pickedDate =
                                                  await showModalBottomSheet<
                                                    DateTime?
                                                  >(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    isDismissible: true,
                                                    enableDrag: true,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                  40.r,
                                                                ),
                                                          ),
                                                    ),
                                                    builder: (_) =>
                                                        BottomsheetDateShow(
                                                          dateSetFieldConfig:
                                                              fieldConfig
                                                                  .dateSetFieldConfig!,
                                                          state: formState,
                                                        ),
                                                  );

                                              fieldConfig.dateSetFieldConfig!
                                                  .setter(ref, pickedDate);
                                            },
                                            errorText: fieldConfig.errorGetter
                                                ?.call(formState),
                                          );
                                        },
                                      );
                                  }
                                },
                              ),
                              /* if (idx != carInfoField.length - 1)
                                SizedBox(height: 42.h), */
                            ],
                          ],
                        ),
                      ),

                      if (currentPage == 3) SizedBox(height: 100.h),
                      if (currentPage == 4) SizedBox(height: 100.h),

                      DotIndicator(currentPage: currentPage, count: count),
                      SizedBox(height: 24.h),
                      OnboardingButton(
                        currentPage: currentPage,
                        onPressed: onNext,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
