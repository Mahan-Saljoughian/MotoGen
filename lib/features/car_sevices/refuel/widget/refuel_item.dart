import 'package:flutter/widgets.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/core/services/format_functions.dart';
import 'package:motogen/features/car_sevices/refuel/model/refuel_state_item.dart';

class RefuelItem extends StatelessWidget {
  final RefuelStateItem refuelItem;
  const RefuelItem({super.key, required this.refuelItem});

  @override
  Widget build(BuildContext context) {
    final titleByIndex = ["تاریخ:", "مقدار افزوده:", "روش پرداخت:", "هزینه:"];
    final valueByIndex = [
      formatJalaliDate(refuelItem.date!),
      formatLiter(refuelItem.liters!),
      refuelItem.paymentMethod?.title,
      formatTomanCost(refuelItem.cost!),
    ];

    return InnerShadow(
      shadows: [
        BoxShadow(
          blurRadius: 5,
          offset: Offset(0, 0),
          color: Color(0xFF14213D).withAlpha(51),
        ),
      ],
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: 180.h),
        padding: EdgeInsets.only(
          right: 15.w,
          left: 15.w,
          top: 25.h,
          bottom: 18.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.blue75,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            for (int index = 0; index < titleByIndex.length; index++) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    titleByIndex[index],
                    style: TextStyle(
                      color: AppColors.blue500,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0,
                    ),
                  ),

                  Text(
                    "${valueByIndex[index]}",
                    style: TextStyle(
                      color: AppColors.blue500,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 9.h),
            ],
            SizedBox(height: 18.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        "بیشتر",
                        style: TextStyle(
                          color: Color(0xFF4A79D8),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0,
                        ),
                      ),
                      SvgPicture.asset(
                        AppIcons.arrowDown,
                        width: 14.w,
                        height: 14.16.h,
                        colorFilter: ColorFilter.mode(
                          Color(0xFF4A79D8),
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 84.w,
                    height: 21.h,
                    decoration: BoxDecoration(
                      color: AppColors.blue400,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppIcons.edit,
                          width: 10.w,
                          height: 10.h,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          "ویرایش",
                          style: TextStyle(
                            color: AppColors.blue50,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
