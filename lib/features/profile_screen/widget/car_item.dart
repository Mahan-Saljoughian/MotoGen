import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/core/constants/app_images.dart';
import 'package:motogen/core/global_error_handling/app_with_container.dart';
import 'package:motogen/core/global_error_handling/viewmodel/global_error_provider.dart';
import 'package:motogen/core/services/custom_exceptions.dart';
import 'package:motogen/core/services/fade_route.dart';
import 'package:motogen/core/services/format_functions.dart';
import 'package:motogen/core/services/logger.dart';
import 'package:motogen/features/car_info/viewmodels/car_state_notifier.dart';
import 'package:motogen/features/car_info/viewmodels/car_use_case_api.dart';

import 'dart:math' as math;

import 'package:motogen/features/bottom_sheet/widgets/confirm_bottom_sheet.dart';
import 'package:motogen/features/car_info/views/car_form_screen.dart';
import 'package:motogen/widgets/snack_bar.dart';

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

    final kilometerTextColor = index % 2 == 0
        ? Color(0xFFFEFEFE)
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
              bottom: 0.h,
            ),

            decoration: BoxDecoration(
              color: backGroundColor,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Stack(
              children: [
                if (editMode)
                  Row(
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
                            isPopOnce: true,
                            onConfirm: () async {
                              try {
                                await ref
                                    .read(carStateNotifierProvider.notifier)
                                    .deleteSelectedCar(carId);

                                // Optional: show success snackbar here if delete doesn’t throw
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    buildCustomSnackBar(
                                      message: 'خودرو حذف شد',
                                      type: SnackBarType.success,
                                    ),
                                  );
                                }
                              } on ForceUpdateException catch (e) {
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                                GlobalErrorHandler.handle(e);
                                rethrow;
                              } catch (err, st) {
                                // other errors
                                appLogger.e('delete car error: $err\n$st');
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    buildCustomSnackBar(
                                      message: 'خطا در حذف خودرو',
                                      type: SnackBarType.error,
                                    ),
                                  );
                                }
                              }
                            },
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
                  ),
                if (currentCar.nickName!.isEmpty) ...[
                  Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Text(
                      "${currentCar.brand?.title} ${currentCar.model?.title} ${currentCar.type?.title}",

                      style: TextStyle(
                        color: carNameTextColor,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ] else ...[
                  Text(
                    currentCar.nickName ?? "",
                    style: TextStyle(
                      color: nickNameTextColor,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (currentCar.nickName!.isEmpty) ...[
                          SizedBox(height: 30.h),
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
                            child: Row(
                              children: [
                                Text(
                                  "لقب انتخاب کن",
                                  style: TextStyle(
                                    color: carNameTextColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SvgPicture.asset(
                                  AppIcons.arrowLeft,
                                  colorFilter: ColorFilter.mode(
                                    carNameTextColor,
                                    BlendMode.srcIn,
                                  ),
                                  width: 16.w,
                                  height: 16.h,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                        ] else ...[
                          SizedBox(height: 30.h),
                          Container(
                            constraints: BoxConstraints(maxWidth: 100.w),
                            child: Text(
                              "${currentCar.brand?.title} ${currentCar.model?.title} ${currentCar.type?.title}",
                              style: TextStyle(
                                color: carNameTextColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],

                        Text(
                          "${formatNumberByThreeDigit(currentCar.kilometer!)} کیلومتر",
                          style: TextStyle(
                            color: kilometerTextColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
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
