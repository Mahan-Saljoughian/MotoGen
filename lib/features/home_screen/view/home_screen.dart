import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/features/car_info/viewmodels/car_state_notifier.dart';
import 'package:motogen/features/home_screen/widget/service_navigator.dart';
import 'package:motogen/features/reminder_screen.dart/viewmodel/reminder_notifier.dart';
import 'package:motogen/features/reminder_screen.dart/widgets/time_left_circle.dart';
import 'package:motogen/features/profile_screen/widget/car_item.dart';
import 'package:motogen/features/user_info/viewmodels/personal_info_controller_view_model.dart';
import 'package:motogen/features/user_info/viewmodels/phone_number_controller_view_model.dart';
import 'package:motogen/widgets/add_car_card.dart';
import 'package:motogen/widgets/loading_animation.dart';
import 'package:motogen/widgets/my_app_bar.dart';

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

    final asyncReminders = ref.watch(reminderNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.blue50,
      body: Column(
        children: [
          MyAppBar(titleText: "خانه"),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (!carFormState.hasCars) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 27.w),
                      child: AddCarCard(),
                    ),
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
                          asyncReminders.when(
                            data: (reminders) {
                              final fixedDateFiltered = reminders.where((
                                reminder,
                              ) {
                                final isFixedDate =
                                    reminder.intervalType.name ==
                                        "FIXED_DATE" &&
                                    reminder.haveBaseValue &&
                                    reminder.enabled;
                                final intervalValue = reminder.intervalValue;

                                final remainingValue =
                                    reminder.remainingValue ?? 0;
                                final percent = remainingValue / intervalValue;
                                final isAlert = percent <= 0.4;

                                return isFixedDate && isAlert;
                              }).toList();

                              final serviceFiltered = reminders.where((
                                reminder,
                              ) {
                                final isService =
                                    reminder.intervalType.name !=
                                        "FIXED_DATE" &&
                                    reminder.haveBaseValue &&
                                    reminder.enabled;

                                final intervalValue = reminder.intervalValue;

                                final remainingValue =
                                    reminder.remainingValue ?? 0;
                                final percent = remainingValue / intervalValue;
                                final isAlert = percent <= 0.4;

                                return isService && isAlert;
                              }).toList();

                              return ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  if (fixedDateFiltered.isNotEmpty) ...[
                                    Text(
                                      "چیزی تا اتمام اعتبارشون باقی نمونده...",
                                      style: TextStyle(
                                        color: AppColors.blue900,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 23.h),
                                    SizedBox(
                                      height: 140.h,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: fixedDateFiltered.length,
                                        separatorBuilder: (_, _) =>
                                            SizedBox(width: 12.w),
                                        itemBuilder: (context, index) {
                                          return TimeLeftCircle(
                                            reminderItem:
                                                fixedDateFiltered[index],
                                            isHomeScreen: true,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                  if (serviceFiltered.isNotEmpty) ...[
                                    Text(
                                      "یادت نره سرویس و بررسی کنی!",
                                      style: TextStyle(
                                        color: AppColors.blue900,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 23.h),
                                    SizedBox(
                                      height: 140.h,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: serviceFiltered.length,
                                        separatorBuilder: (_, _) =>
                                            SizedBox(width: 12.w),
                                        itemBuilder: (context, index) {
                                          return TimeLeftCircle(
                                            reminderItem:
                                                serviceFiltered[index],
                                            isHomeScreen: true,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ],
                              );
                            },
                            loading: () =>
                                const Center(child: LoadingAnimation(size: 50)),
                            error: (err, stack) =>
                                Text("خطا در بارگیری یادآورها"),
                          ),
                          SizedBox(height: 28.h),
                          Text(
                            "هرکاری برای ماشینت کردی اینجا ثبت کن!",
                            style: TextStyle(
                              color: AppColors.blue900,
                              height: 1.8,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
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
