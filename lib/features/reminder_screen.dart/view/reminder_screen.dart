import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/features/reminder_screen.dart/model/reminder_state_item.dart';
import 'package:motogen/features/reminder_screen.dart/viewmodel/reminder_notifier.dart';
import 'package:motogen/features/reminder_screen.dart/widgets/time_left_circle.dart';
import 'package:motogen/widgets/loading_animation.dart';
import 'package:motogen/widgets/my_app_bar.dart';

class ReminderScreen extends ConsumerWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncReminders = ref.watch(reminderNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.blue50,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 39.w),
          child: asyncReminders.when(
            loading: () => const Center(child: LoadingAnimation()),
            error: (e, st) {
              debugPrint("error in remindersPage with $e , $st");
              return Center(child: Text("خطا در بارگذاری یادآورها"));
            },
            data: (reminders) {
              debugPrint("debug ${reminders.toString()}");
              for (final item in reminders) {
                debugPrint(
                  'debug id: ${item.reminderId}, type: ${item.type}, intervalType: ${item.intervalType}, intervalValue: ${item.intervalValue}',
                );
              }
              for (final r in reminders) {
                debugPrint(
                  'debug type raw: "${r.type}" (${r.type.runtimeType})  →  id: ${r.reminderId}',
                );
              }

              final daysList = reminders
                  .where((r) => r.intervalType == IntervalType.DAYS)
                  .toList();
              final kmList = reminders
                  .where((r) => r.intervalType == IntervalType.KILOMETERS)
                  .toList();
              final fixedDateList = reminders
                  .where((r) => r.intervalType == IntervalType.FIXED_DATE)
                  .toList();
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyAppBar(titleText: "یادآور"),
                    SizedBox(height: 13.h),
                    _buildSection(
                      title: "یادآوری بر حسب زمان",
                      reminders: daysList,
                    ),
                    _buildSection(
                      title: "یادآوری بر حسب کیلومتر",
                      reminders: kmList,
                    ),
                    _buildSection(title: "اعتبار", reminders: fixedDateList),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<ReminderStateItem> reminders,
  }) {
    if (reminders.isEmpty) return const SizedBox.shrink();

    final reminderIdByType = {for (final r in reminders) r.type: r.reminderId};

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF14213D),
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 26.h),

       // lazy build reminders 
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: (reminders.length / 2).ceil(), // For 2 columns
            itemBuilder: (context, rowIndex) {
              final int firstIndex = rowIndex * 2;
              final int secondIndex = firstIndex + 1;
              return Row(
                children: [
                  Expanded(
                    child: firstIndex < reminders.length
                        ? TimeLeftCircle(
                            isHomeScreen: false,
                            reminderItem: reminder,
                            reminderIdByType: reminderIdByType,
                          )
                        : SizedBox(),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: secondIndex < reminders.length
                        ? TimeLeftCircle(
                            isHomeScreen: false,
                            reminderItem: reminder,
                            reminderIdByType: reminderIdByType,
                          )
                        : SizedBox(),
                  ),
                ],
              );
            },
          ),

          /*  Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: reminders.map((reminder) {
              return TimeLeftCircle(
                isHomeScreen: false,
                reminderItem: reminder,
                reminderIdByType: reminderIdByType,
              );
            }).toList(),
          ), */
        ],
      ),
    );
  }
}
