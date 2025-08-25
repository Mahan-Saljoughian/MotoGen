import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/core/services/fade_route.dart';
import 'package:motogen/features/car_info/views/car_form_screen.dart';

class AddCarCard extends StatelessWidget {
  const AddCarCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        FadeRoute(page: CarFormScreen(mode: CarInfoFormMode.addEdit)),
      ),
      child: InnerShadow(
        shadows: [
          BoxShadow(
            blurRadius: 8,
            offset: Offset(0, 0),
            color: Color(0xFF14213D).withAlpha(51),
          ),
        ],
        child: Container(
          width: double.infinity,
          height: 160.h,
          padding: EdgeInsets.only(top: 28.h, bottom: 17.h),
          decoration: BoxDecoration(
            color: AppColors.blue300,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Column(
            children: [
              Text(
                "ماشینت رو ثبت نکردی!",
                style: TextStyle(
                  color: AppColors.white50,
                  height: 0,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 18.h),
              SvgPicture.asset(
                AppIcons.addCircle,
                width: 54.w,
                height: 54.h,
                colorFilter: ColorFilter.mode(
                  AppColors.blue50,
                  BlendMode.srcIn,
                ),
              ),

              Text(
                "افزودن خودرو",
                style: TextStyle(
                  color: AppColors.white50,
                  height: 0,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
