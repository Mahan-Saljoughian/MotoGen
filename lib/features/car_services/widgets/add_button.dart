import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/features/car_services/refuel/view/refuel_form_screen.dart';

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 45.w, bottom: 98.h),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RefuelFormScreen()),
          );
        },
        child: Container(
          width: 60,
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: AppColors.orange500,
            borderRadius: BorderRadius.circular(50.r),
          ),
          child: SvgPicture.asset(
            AppIcons.add,
            colorFilter: ColorFilter.mode(AppColors.orange50, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
