import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';


class FieldText extends StatefulWidget {
  final TextEditingController controller;
  final bool isValid;
  final String labelText;
  final String hintText;
  final String? error;
  final bool isBackError;
  final void Function(String)? onChanged;

  const FieldText({
    super.key,
    required this.controller,
    required this.isValid,
    required this.labelText,
    required this.hintText,
    this.onChanged,
    this.error,
    this.isBackError = false,
  });

  @override
  State<FieldText> createState() => _FieldTextState();
}

class _FieldTextState extends State<FieldText> {
  bool isInteractedOnce = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          keyboardType:
              (widget.labelText == "شماره موبایل" ||
                  widget.labelText == "کیلومتر")
              ? TextInputType.number
              : TextInputType.text,
          controller: widget.controller,
          onChanged: widget.onChanged,
          onSubmitted: (value) {
            if (!isInteractedOnce) {
              setState(() {
                isInteractedOnce = true;
              });
            }
          },

          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: TextStyle(
              color: widget.isValid || isInteractedOnce == false
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
                color: widget.isValid || isInteractedOnce == false
                    ? AppColors.blue500
                    : Color(0xFFC60B0B),
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                width: 1.5,
                color: widget.isValid || isInteractedOnce == false
                    ? AppColors.blue500
                    : Color(0xFFC60B0B),
              ),
            ),

            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: AppColors.black100,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
            contentPadding: EdgeInsets.only(right: 24.w),
            suffixIcon:
                widget.error != null &&
                    isInteractedOnce == true &&
                    widget.labelText != "شماره موبایل" &&
                    widget.labelText != "لقب"
                ? Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: SvgPicture.asset(
                      AppIcons.errorCircle,
                      height: 24.h,
                      width: 24.w,
                    ),
                  )
                : null,

            suffixIconConstraints: BoxConstraints(
              minWidth: 24.w,
              minHeight: 24.w,
            ),
          ),
        ),

        if (widget.error != null &&
            (isInteractedOnce == true || widget.isBackError))
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                widget.error ?? "",
                style: TextStyle(
                  color: Color(0xFFC60B0B),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        if (widget.error != null &&
            isInteractedOnce == false &&
            !widget.isBackError)
          SizedBox(height: 30.h),
        if (widget.error == null) SizedBox(height: 30.h),
      ],
    );
  }
}
