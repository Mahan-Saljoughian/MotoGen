import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';

class HelpToAddTextBox extends StatelessWidget {
  final String helpText;
  const HelpToAddTextBox({super.key, required this.helpText});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 242.w,
          height: 58.h,
          padding: EdgeInsets.only(
            left: 7.w,
            top: 5.h,
            right: 15.w,
            bottom: 4.w,
          ),
          decoration: BoxDecoration(
            color: AppColors.blue500,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Text(
            helpText,
            style: TextStyle(
              color: AppColors.blue50,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              height: 2.01,
              letterSpacing: 0.30,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: -4.5.w,
          child: SvgPicture.asset(
            AppIcons.whiteTailRight,
            colorFilter: ColorFilter.mode(AppColors.blue500, BlendMode.srcIn),
            width: 20.w,
            height: 14.h,
          ),
        ),
      ],
    );
  }
}
