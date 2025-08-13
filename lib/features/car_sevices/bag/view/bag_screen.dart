import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/core/constants/app_images.dart';
import 'package:motogen/features/car_sevices/widgets/help_to_add_text_box.dart';

class BagScreen extends StatelessWidget {
  const BagScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 20.h, right: 20.w, left: 20.w),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, "/mainApp"),
                    child: SvgPicture.asset(
                      AppIcons.arrowRight,
                      width: 24.w,
                      height: 24.h,
                    ),
                  ),
                  SizedBox(width: 143.w),
                  Text(
                    "خرید",
                    style: TextStyle(
                      color: AppColors.blue500,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 242.h),

              Image.asset(AppImages.bag, width: 107.w, height: 163.h),
              SizedBox(height: 43.h),
              Text(
                "هنوز خریدی رو ثبت نکردی!",
                style: TextStyle(
                  color: AppColors.blue600,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 160.h),
              Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: HelpToAddTextBox(
                  helpText: "برای اضافه کردن خرید جدید روی این دکمه بزن.",
                ),
              ),
              SizedBox(height: 7.h),
              /*  AddButton(), */
            ],
          ),
        ),
      ),
    );
  }
}
