import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/viewmodels/car_info/car_info_form_viewmodel.dart';

import 'package:motogen/views/onboarding/car_info/car_info_field_config.dart';

import 'package:motogen/views/widgets/bottomsheet_List_show.dart';
import 'package:motogen/views/widgets/bottomsheet_picker_field.dart';


class CarInfoScreen extends ConsumerWidget {
  final VoidCallback onBack;
  final List<CarInfoFieldConfig> pickerFields;
  const CarInfoScreen(this.onBack, this.pickerFields, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carInfoFormViewmodel = ref.read(carInfoFormProvider.notifier);
    final kilometerText = ref.watch(
      carInfoFormProvider.select((s) => s.rawKilometersInput),
    );
    final isKmValid =
        int.tryParse(kilometerText ?? '') != null &&
        int.parse(kilometerText!) > 0 &&
        int.parse(kilometerText) < 10000000;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(vertical: 20.h),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
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
                ),

                SizedBox(height: 120.h),

                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 40.w),
                  child: Column(
                    children: [
                      for (int idx = 0; idx < pickerFields.length; idx++) ...[
                        if (pickerFields[idx].type == FieldInputType.picker)
                          Consumer(
                            builder: (context, ref, _) {
                              final formState = ref.watch(carInfoFormProvider);
                              return BottomsheetPickerField(
                                labelText: pickerFields[idx].labelText,
                                selectedItem: pickerFields[idx].pickerConfig!
                                    .getter(formState),
                                onPressed: () =>
                                    BottomsheetListShow.showSelectionBottomSheet(
                                      context: context,
                                      config: pickerFields[idx].pickerConfig!,
                                      ref: ref,
                                      state: formState,
                                    ),
                              );
                            },
                          )
                        else if (pickerFields[idx].type == FieldInputType.text)
                          TextField(
                            controller:
                                carInfoFormViewmodel.kilometeDrivenController,
                            keyboardType: TextInputType.number,
                            onChanged: (text) {
                              carInfoFormViewmodel.setRawKilometerInput(text);
                            },
                            decoration: InputDecoration(
                              labelText: pickerFields[idx].labelText,
                              labelStyle: TextStyle(
                                color: isKmValid
                                    ? AppColors.blue500
                                    : Color(0xFFC60B0B),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(
                                  width: 1.5.w,
                                  color: isKmValid
                                      ? AppColors.blue500
                                      : Color(0xFFC60B0B),
                                ),
                              ),

                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(
                                  width: 1.5,
                                  color: isKmValid
                                      ? AppColors.blue500
                                      : Color(0xFFC60B0B),
                                ),
                              ),

                              hintText: kilometerText ?? "انتخاب کنید...",
                              hintStyle: TextStyle(
                                color: AppColors.black100,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              contentPadding: EdgeInsets.only(right: 24.w),
                            ),
                          ),
                        if (idx != pickerFields.length - 1)
                          SizedBox(height: 42.h),
                      ],
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
