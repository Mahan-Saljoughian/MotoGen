import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/features/car_info/viewmodels/car_state_notifier.dart';
import 'package:motogen/features/home_screen/widget/service_navigator.dart';
import 'package:motogen/features/home_screen/widget/time_left_circle.dart';
import 'package:motogen/features/profile_screen/widget/car_item.dart';
import 'package:motogen/features/user_info/viewmodels/personal_info_controller_view_model.dart';
import 'package:motogen/features/user_info/viewmodels/phone_number_controller_view_model.dart';


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = Logger();
    final personalInfocontroller = ref.watch(personalInfoProvider);
    final phoneNumberController = ref.watch(phoneNumberControllerProvider);
    final carFormState = ref.watch(carStateNotifierProvider);
    logger.i(
      "debug user info : firstname: ${personalInfocontroller.nameController.text} , lastName: ${personalInfocontroller.lastNameController.text} , phoneNumber:${phoneNumberController.phoneController.text}",
    );
    logger.i("debug car info : ${carFormState.currentCar?.toJson()}");
    /*  for (var i = 0; i < carFormState.cars.length; i++) {
      logger.i("debug Car $i: ${carFormState.cars[i].toJson()}");
    } */
    return Scaffold(
      backgroundColor: AppColors.blue50,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            alignment: Alignment.center,
            child: Text(
              "خانه",
              style: TextStyle(
                color: AppColors.blue500,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (!carFormState.hasCars) ...[
                    Text("no cars available"),
                  ] else ...[
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (
                            var i = 0;
                            i < carFormState.cars.length;
                            i++
                          ) ...[
                            if (i == 0 && carFormState.cars.length > 1)
                              SizedBox(width: 40.w),
                            CarItem(
                              index: i,
                              carId: carFormState.cars[i].carId ?? "",
                              nickName: carFormState.cars[i].nickName ?? "",
                              brandTitle:
                                  carFormState.cars[i].brand?.title ?? "",
                              modelTitle:
                                  carFormState.cars[i].model?.title ?? "",
                              typeTitle: carFormState.cars[i].type?.title ?? "",
                              editMode: false,
                            ),
                            // Middle spacing
                            if (i != carFormState.cars.length - 1)
                              SizedBox(width: 16.w),

                            // Right padding only for last item
                            if (i == carFormState.cars.length - 1 &&
                                carFormState.cars.length > 1)
                              SizedBox(width: 40.w),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: 31.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "چیزی تا اتمام اعتبارشون باقی نمونده...",
                            style: TextStyle(
                              color: AppColors.blue900,
                              height: 0,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0,
                            ),
                          ),
                          SizedBox(height: 23.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TimeLeftCircle(
                                daysLeft: 50,
                                totalDays: 100,
                                serviceTitle: "بیمه بدنه",
                              ),
                              TimeLeftCircle(
                                daysLeft: 40,
                                totalDays: 100,
                                serviceTitle: "معاینه فنی",
                              ),
                              TimeLeftCircle(
                                daysLeft: 20,
                                totalDays: 100,
                                serviceTitle: "بیمه شخص ثالث",
                              ),
                            ],
                          ),
                          SizedBox(height: 23.h),
                          Text(
                            "یادت نره سرویس و بررسی کنی!",
                            style: TextStyle(
                              color: AppColors.blue900,
                              height: 0,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0,
                            ),
                          ),
                          SizedBox(height: 23.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TimeLeftCircle(
                                daysLeft: 50,
                                totalDays: 100,
                                serviceTitle: "بررسی آب و روغن",
                              ),
                              TimeLeftCircle(
                                daysLeft: 40,
                                totalDays: 100,
                                serviceTitle: "تنظیم باد لاستیک",
                              ),
                              TimeLeftCircle(
                                daysLeft: 20,
                                totalDays: 100,
                                serviceTitle: "تعویض روغن ترمز",
                              ),
                            ],
                          ),
                          SizedBox(height: 28.h),
                          Text(
                            "هرکاری برای ماشینت کردی اینجا ثبت کن!",
                            style: TextStyle(
                              color: AppColors.blue900,
                              height: 1.8,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ServiceNavigator(
                                serviceTitle: ServiceTitle.refuel,
                              ),

                              ServiceNavigator(serviceTitle: ServiceTitle.oil),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ServiceNavigator(
                                serviceTitle: ServiceTitle.repair,
                              ),

                              ServiceNavigator(
                                serviceTitle: ServiceTitle.purchases,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
