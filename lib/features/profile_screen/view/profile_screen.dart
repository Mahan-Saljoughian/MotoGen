import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/features/car_info/viewmodels/car_state_notifier.dart';
import 'package:motogen/features/profile_screen/widget/car_item.dart';
import 'package:motogen/features/profile_screen/widget/more_bottom_sheet.dart';
import 'package:motogen/features/user_info/viewmodels/personal_info_controller_view_model.dart';
import 'package:motogen/features/user_info/viewmodels/phone_number_controller_view_model.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carFormState = ref.watch(carStateNotifierProvider);
    final personalInfoController = ref.watch(personalInfoProvider);
    final phoneNumberController = ref.watch(phoneNumberControllerProvider);
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
                    AppIcons.more,
                    width: 23.w,
                    height: 29.9.h,
                  ),
                ),
              ],
            ),
            SizedBox(height: 28.h),

            Container(
              height: 100.h,
              padding: EdgeInsets.only(
                left: 14.w,
                right: 21.w,
                top: 14.h,
                bottom: 14.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.blue300,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.profileCircle,
                        width: 70.w,
                        height: 70.w,
                      ),
                      SizedBox(width: 18.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            " ${personalInfoController.nameController.text} ${personalInfoController.lastNameController.text}",
                            style: TextStyle(
                              color: AppColors.blue50,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            phoneNumberController.phoneController.text,
                            style: TextStyle(
                              color: AppColors.blue50,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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

            SizedBox(height: 40.h),
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
            SizedBox(height: 21.h),

            if (!carFormState.hasCars) ...[
              Text("no cars available"),
            ] else ...[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: carFormState.cars.asMap().entries.map((entry) {
                    final index = entry.key;
                    final car = entry.value;
                    return CarItem(
                      index: index,
                      carId: car.carId ?? "",
                      nickName: car.nickName ?? "",
                      brandTitle: car.brand?.title ?? "",
                      modelTitle: car.model?.title ?? "",
                      typeTitle: car.type?.title ?? "",
                    );
                  }).toList(),
                ),
              ),
            ],
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 45,
                height: 45,
                padding: EdgeInsets.symmetric(
                  horizontal: 13.5.w,
                  vertical: 13.5.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.blue100,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: SvgPicture.asset(
                  AppIcons.add,
                  width: 18.w,
                  height: 18.h,
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              "افزودن خودرو",
              style: TextStyle(
                color: AppColors.blue300,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
