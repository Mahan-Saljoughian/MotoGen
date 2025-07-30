import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/features/car_info/viewmodels/car_info_form_viewmodel.dart';

class BottomsheetPickerField extends ConsumerWidget {
  final String labelText;
  final String? selectedText;
  final VoidCallback onPressed;
  final String? errorText;

  const BottomsheetPickerField({
    super.key,
    required this.labelText,
    required this.selectedText,
    required this.onPressed,
    this.errorText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String hintText = "انتخاب کنید...";
    String displayText;
    displayText = selectedText ?? hintText;
    bool defaultDisable = true;

    if (displayText == "default" || displayText == "-1") {
      displayText = hintText;
      defaultDisable = false;
    }

    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onPressed,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: TextStyle(
                color: errorText == null
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
                  color: errorText == null
                      ? AppColors.blue500
                      : Color(0xFFC60B0B),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(width: 1.5, color: AppColors.blue500),
              ),
              suffixIcon: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: //Icon(Icons.keyboard_arrow_down),
                SvgPicture.asset(
                  AppIcons.arrowDown,
                  height: 24.h,
                  width: 24.w,

                  colorFilter: ColorFilter.mode(
                    errorText == null
                        ? AppColors.blue500
                        : Color(0xFFC60B0B), // Desired color
                    BlendMode.srcIn,
                  ),
                ),
              ),
              suffixIconConstraints: BoxConstraints(
                minWidth: 24.w,
                minHeight: 24.w,
              ),
              contentPadding: EdgeInsets.only(right: 24.w),
            ),
            child: Text(
              displayText,
              style: TextStyle(
                color: selectedText != null && defaultDisable
                    ? AppColors.black600
                    : AppColors.black100,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                errorText!,
                style: TextStyle(
                  color: Color(0xFFC60B0B),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        if (errorText == null) SizedBox(height: 42.h),
      ],
    );
  }
}
