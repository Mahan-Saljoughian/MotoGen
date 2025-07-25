import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/views/onboarding/car_info/picker_item.dart';

class BottomsheetPickerField extends ConsumerWidget {
  final String labelText;
  final PickerItem? selectedItem;
  final VoidCallback onPressed;

  const BottomsheetPickerField({
    super.key,
    required this.labelText,
    required this.selectedItem,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String hintText = "انتخاب کنید...";
    String displayText;
    displayText = selectedItem?.title ?? hintText;
    bool defaultDisable = true;

    if (displayText == "default" || displayText == "-1") {
      displayText = hintText;
      defaultDisable = false;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: AppColors.blue500,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(width: 1.5.w, color: AppColors.blue500),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(width: 1.5, color: AppColors.blue500),
          ),
          suffixIcon: Padding(
            padding:  EdgeInsets.only(left: 10.w),
            child: Icon(Icons.keyboard_arrow_down),
            //SvgPicture.asset("assets/icons/arrow-down.svg"),
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
            color: selectedItem != null && defaultDisable
                ? AppColors.black600
                : AppColors.black100,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
