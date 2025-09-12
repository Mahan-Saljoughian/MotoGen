import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/core/services/fade_route.dart';
import 'package:motogen/features/car_info/viewmodels/car_state_notifier.dart';
import 'package:motogen/features/profile_screen/widget/car_item.dart';
import 'package:motogen/features/profile_screen/widget/more_bottom_sheet.dart';
import 'package:motogen/features/user_info/viewmodels/personal_info_controller_view_model.dart';
import 'package:motogen/features/user_info/viewmodels/phone_number_controller_view_model.dart';
import 'package:motogen/features/user_info/views/personal_info_screen.dart';
import 'package:motogen/widgets/add_car_card.dart';
import 'package:motogen/widgets/my_app_bar.dart';
import 'package:motogen/widgets/snack_bar.dart';

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
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          children: [
            MyAppBar(
              titleText: "پروفایل",
              ontapFunction: () => showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(40.r),
                  ),
                ),
                builder: (context) => MoreBottomSheet(),
              ),
              isMore: true,
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
                          Container(
                            constraints: BoxConstraints(maxWidth: 200.w),
                            child: Text(
                              " ${personalInfoController.nameController.text} ${personalInfoController.lastNameController.text}",
                              style: TextStyle(
                                color: AppColors.blue50,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
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
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          FadeRoute(
                            page: PersonalInfoScreen(
                              onNext: () {},

                              isEdit: true,
                            ),
                          ),
                        ),
                        child: SvgPicture.asset(
                          AppIcons.edit,
                          width: 24.w,
                          height: 24.h,
                        ),
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
              AddCarCard(),
            ] else ...[
              Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var i = 0; i < carFormState.cars.length; i++) ...[
                          CarItem(
                            index: i,
                            carId: carFormState.cars[i].carId ?? "",
                            editMode: true,
                          ),
                          // Middle spacing
                          if (i != carFormState.cars.length - 1)
                            SizedBox(width: 16.w),
                        ],
                      ],
                    ),
                  ),

                  // add car button
                  /*  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap:
                        () => /* Navigator.push(
                      context,
                      FadeRoute(
                        page: CarFormScreen(mode: CarInfoFormMode.addEdit),
                      ),
                    ), */ ScaffoldMessenger.of(context).showSnackBar(
                          buildCustomSnackBar(
                            message: 'لاب بزن',
                            type: SnackBarType.error,
                          ),
                        ),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          AppIcons.addCircle,
                          width: 54.w,
                          height: 54.h,
                        ),
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
                  ), */
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
