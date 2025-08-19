import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/features/car_services/oil/view/oil_form_screen.dart';
import 'package:motogen/features/car_services/refuel/view/refuel_form_screen.dart';
import 'package:motogen/features/car_services/repair/view/repair_from_screen.dart';
import 'package:motogen/features/home_screen/widget/service_navigator.dart';

class AddButton extends StatelessWidget {
  final ServiceTitle serviceTitle;
  const AddButton({super.key, required this.serviceTitle});

  @override
  Widget build(BuildContext context) {
    final onTapFunction = [
      () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => RefuelFormScreen()),
      ),
      () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => OilFormScreen()),
      ),

      () {},
      () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => RepairFromScreen()),
      ),
    ];
    return GestureDetector(
      onTap: onTapFunction[serviceTitle.index],
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
    );
  }
}
