import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_icons.dart';

enum SnackBarType { success, error }

SnackBar buildCustomSnackBar({String? message, required SnackBarType type}) {
  final isError = type == SnackBarType.error;
  final defaultMessage = isError ? "خطای سرور!" : "با موفقیت انجام شد!";
  message = message ?? defaultMessage;
  final snackBarColor = isError ? Color(0xFFC60B0B) : Color(0xFF3C9452);
  return SnackBar(
    backgroundColor: Color(0xFFFFFFFF).withAlpha(26),
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    //    margin: EdgeInsets.only(bottom: 125.h),
    content: Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 13.h),
      decoration: BoxDecoration(
        border: Border.all(color: snackBarColor, width: 2),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            isError ? AppIcons.errorCircleFilled : AppIcons.tickCircleFilled,
            colorFilter: ColorFilter.mode(snackBarColor, BlendMode.srcIn),
            width: 30.w,
            height: 30.h,
          ),
          SizedBox(width: 12.w),
          Text(
            message,
            style: TextStyle(
              color: snackBarColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}
