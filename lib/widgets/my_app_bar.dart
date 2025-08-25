import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';

class MyAppBar extends StatelessWidget {
  final String titleText;
  final VoidCallback? ontapFunction;
  final bool isBack;
  final bool isMore;
  const MyAppBar({
    super.key,
    required this.titleText,
    this.ontapFunction,
    this.isBack = false,
    this.isMore = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Stack(
        children: [
          if (isBack)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: GestureDetector(
                  onTap: ontapFunction,
                  child: SvgPicture.asset(
                    AppIcons.arrowRight,
                    width: 24.w,
                    height: 24.h,
                  ),
                ),
              ),
            ),

          Align(
            alignment: Alignment.center,
            child: Text(
              titleText,
              style: TextStyle(
                color: AppColors.blue500,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          if (isMore)
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: ontapFunction,
                child: SvgPicture.asset(
                  AppIcons.more,
                  width: 23.w,
                  height: 29.9.h,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
