import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/features/profile_screen/widget/car_item.dart';
import 'package:motogen/features/profile_screen/widget/more_bottom_sheet.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue50,

      body: Padding(
        padding: EdgeInsets.only(top: 20.h, left: 30.w, right: 30.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "پروفایل",
                  style: TextStyle(
                    color: AppColors.blue500,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 138.w),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(40.r),
                        ),
                      ),
                      builder: (context) => MoreBottomSheet(),
                    );
                  },
                  child: SvgPicture.asset(
                    AppIcons.moreCircle,
                    width: 23.w,
                    height: 29.9.h,
                  ),
                ),
              ],
            ),
            SizedBox(height: 28.h),

            Container(
              height: 150.h,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: Color(0xFFD0D6E3),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppIcons.profileCircle,
                    width: 120.w,
                    height: 120.w,
                  ),
                  Column(
                    children: [
                      SizedBox(height: 36.h),
                      Text(
                        "علی علیزاده",
                        style: TextStyle(
                          color: AppColors.blue500,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "09123456789",
                        style: TextStyle(
                          color: AppColors.blue500,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(width: 86.w),
                  Column(
                    children: [
                      SvgPicture.asset(
                        AppIcons.edit,
                        width: 24.w,
                        height: 24.h,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 56.h),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "خودروها",
                style: TextStyle(
                  color: AppColors.blue700,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            CarItem(),
            SizedBox(height: 37.h),
            SvgPicture.asset(AppIcons.addCircle, width: 54.w, height: 54.h),
            Text(
              "افزودن خودرو",
              style: TextStyle(
                color: AppColors.blue300,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
