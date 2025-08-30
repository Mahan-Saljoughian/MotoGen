import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/core/constants/app_images.dart';
import 'package:motogen/core/services/fade_route.dart';
import 'package:motogen/features/car_info/viewmodels/car_state_notifier.dart';
import 'package:motogen/features/car_info/viewmodels/car_use_case_api.dart';

import 'dart:math' as math;

import 'package:motogen/features/bottom_sheet/widgets/confirm_bottom_sheet.dart';
import 'package:motogen/features/car_info/views/car_form_screen.dart';

class CarItem extends ConsumerWidget {
  final int index;
  final String carId;
  final bool editMode;

  const CarItem({
    super.key,
    required this.index,
    required this.carId,
    this.editMode = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backGroundColor = index % 2 == 0
        ? AppColors.blue300
        : AppColors.orange300;
    final nickNameTextColor = index % 2 == 0
        ? AppColors.orange300
        : AppColors.blue400;
    final carNameTextColor = index % 2 == 0
        ? Colors.white
        : AppColors.orange900;
    final shadowColor = index % 2 == 0
        ? Color(0xFF14213D).withAlpha(130)
        : Color(0xFFB3740c).withAlpha(153);
    final carImage = index % 2 == 0
        ? AppImages.carCardWhite
        : AppImages.carCardDark;
    final editIconColor = index % 2 == 0 ? AppColors.blue75 : AppColors.blue500;
    final trashIconColor = index % 2 == 0
        ? Color(0xFFE15454)
        : Color(0xFFC60B0B);

    final currentCar = ref
        .read(carStateNotifierProvider.notifier)
        .getCarById(carId);
    return GestureDetector(
      onTap: editMode
          ? () {}
          : () {
              ref.read(carStateNotifierProvider.notifier).selectCar(carId);
            },
      child: InnerShadow(
        shadows: [
          BoxShadow(blurRadius: 8, offset: Offset(0, 0), color: shadowColor),
        ],

        child: Padding(
          padding: EdgeInsets.only(left: 0.w),
          child: Container(
            width: 320.w,
            height: 160.h,
            padding: EdgeInsets.only(
              right: 24.w,
              left: 12.w,
              top: 13.h,
              bottom: 13.h,
            ),

            decoration: BoxDecoration(
              color: backGroundColor,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 24.h,
                  child: editMode
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                FadeRoute(
                                  page: CarFormScreen(
                                    mode: CarInfoFormMode.addEdit,
                                    initialItem: currentCar,
                                  ),
                                ),
                              ),
                              child: SvgPicture.asset(
                                AppIcons.edit,
                                colorFilter: ColorFilter.mode(
                                  editIconColor,
                                  BlendMode.srcIn,
                                ),
                                width: 24.w,
                                height: 24.h,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            GestureDetector(
                              onTap: () async {
                                await showConfirmBottomSheet(
                                  titleText: "برای حذف کردنش مطمئنی؟",
                                  context: context,
                                  isDelete: true,
                                  onConfirm: () {
                                    return ref
                                        .read(carStateNotifierProvider.notifier)
                                        .deleteSelectedCar(carId);
                                  },
                                  isPopOnce: true,
                                );
                              },
                              child: SvgPicture.asset(
                                AppIcons.trash,
                                colorFilter: ColorFilter.mode(
                                  trashIconColor,
                                  BlendMode.srcIn,
                                ),
                                width: 24.w,
                                height: 24.h,
                              ),
                            ),
                          ],
                        )
                      : null,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentCar.nickName ?? "",
                          style: TextStyle(
                            color: nickNameTextColor,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: 100.w,
                          ), 
                          child: Text(
                            "${currentCar.brand?.title} ${currentCar.model?.title} ${currentCar.type?.title}",
                            style: TextStyle(
                              color: carNameTextColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 24.h),
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: Image.asset(
                          carImage,
                          width: 176.w,
                          height: 67.h,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
