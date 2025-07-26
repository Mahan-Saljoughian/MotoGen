import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';

class FieldText extends StatelessWidget {
  final TextEditingController controller;
  final bool isValid;
  final String labelText;
  final String hintText;
  final void Function(String)? onChanged;

  const FieldText({
    super.key,
    required this.controller,
    required this.isValid,
    required this.labelText,
    required this.hintText, this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: (labelText == "شماره موبایل" || labelText == "کیلومتر")
          ? TextInputType.number
          : TextInputType.text,
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: isValid ? AppColors.blue500 : Color(0xFFC60B0B),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            width: 1.5.w,
            color: isValid ? AppColors.blue500 : Color(0xFFC60B0B),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            width: 1.5,
            color: isValid ? AppColors.blue500 : Color(0xFFC60B0B),
          ),
        ),

        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColors.black100,
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
        ),
        contentPadding: EdgeInsets.only(right: 24.w),
      ),
    );
  }
}
