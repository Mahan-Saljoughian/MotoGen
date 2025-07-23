import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motogen/core/constants/app_colors.dart';

class BottomsheetPickerField extends StatelessWidget {
  final String labelText;
  final String? selectedItem;
  final VoidCallback onPressed;

  const BottomsheetPickerField({
    super.key,
    required this.labelText,
    required this.selectedItem,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    String hintText = "انتخاب کنید...";
    String displayText;
    displayText = selectedItem ?? hintText;

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
            padding: const EdgeInsets.only(left: 10),
            child: Icon(Icons.keyboard_arrow_down),
            //SvgPicture.asset("assets/icons/arrow-down.svg"),
          ),
          suffixIconConstraints: BoxConstraints(
            minWidth: 24.w,
            minHeight: 24.w,
          ),
          contentPadding: EdgeInsets.only(right: 24),
        ),
        child: Text(
          displayText,
          style: TextStyle(
            color: selectedItem != null
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
