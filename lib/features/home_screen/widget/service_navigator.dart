import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/features/car_services/base/model/service_model.dart';

enum ServiceTitle { refuel, oil, purchases, repair }


class ServiceNavigator extends StatelessWidget {
  final ServiceTitle serviceTitle;
  const ServiceNavigator({super.key, required this.serviceTitle});
  

  @override
  Widget build(BuildContext context) {
    final index = serviceTitle.index;
    final text = getServiceTitle(serviceTitle);
   
    final iconBasedIndex = [
      {"icon": AppIcons.fuel, "width": 39.w, "height": 48.5.h},
      {"icon": AppIcons.oil, "width": 39.2.w, "height": 45.4.h},
      {"icon": AppIcons.purchases, "width": 35.3.w, "height": 44.2.h},
      {"icon": AppIcons.repair, "width": 45.w, "height": 42.5.h},
    ];
    final backGroundColor = index % 2 == 0
        ? AppColors.orange500
        : AppColors.blue300;
    final shadowColor = index % 2 == 0
        ? Color(0xFFB3740C).withAlpha(204)
        : Color(0xFF14213D).withAlpha(102);

    final onTapFunction = [
      () => Navigator.pushNamed(context, '/refuel'),
      () => Navigator.pushNamed(context, '/oil'),
      () => Navigator.pushNamed(context, '/purchases'),
      () => Navigator.pushNamed(context, '/repair'),
    ];
    return GestureDetector(
      onTap: onTapFunction[index],
      child: InnerShadow(
        shadows: [
          BoxShadow(blurRadius: 4, offset: Offset(0, 0), color: shadowColor),
        ],
        child: Container(
          height: 80.h,
          width: 160.w,
          decoration: BoxDecoration(
            color: backGroundColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                iconBasedIndex[index]['icon'] as String,
                width: iconBasedIndex[index]['width'] as double,
                height: iconBasedIndex[index]['height'] as double,
              ),

              Text(
               text,
                style: TextStyle(
                  color: AppColors.orange50,
                  fontSize: 16.sp,
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
