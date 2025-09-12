import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/services/format_functions.dart';
import 'package:motogen/core/services/logger.dart';
import 'package:motogen/features/reminder_screen.dart/model/reminder_state_item.dart';
import 'package:motogen/features/reminder_screen.dart/viewmodel/reminder_notifier.dart';
import 'package:motogen/features/reminder_screen.dart/viewmodel/reminder_action.dart';
import 'package:motogen/features/reminder_screen.dart/widgets/done_toggle.dart';
import 'package:motogen/features/reminder_screen.dart/widgets/enable_toggle.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TimeLeftCircle extends ConsumerWidget {
  final bool isHomeScreen;
  final ReminderStateItem reminderItem;
  final Map<String, String>? reminderIdByType;

  const TimeLeftCircle({
    super.key,
    required this.reminderItem,
    this.reminderIdByType,
    this.isHomeScreen = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remainingValue = reminderItem.remainingValue ?? 0;

    double percent = remainingValue / reminderItem.intervalValue;
    final farsiTextForType = ReminderStateItem.translate(reminderItem.type);
    final remainingFormatted = formatNumberToPersianK(remainingValue);
    final intervalFormatted = formatNumberToPersianK(
      reminderItem.intervalValue,
    );
    final safeReminderIdByType = reminderIdByType ?? const {};
    final reminderAction = ref
        .read(reminderNotifierProvider.notifier)
        .buildReminderAction(context, ref, safeReminderIdByType);

    final isThousand = isHomeScreen
        ? remainingFormatted.contains("هزار")
        : remainingFormatted.contains("هزار") ||
              intervalFormatted.contains("هزار");

    final doneType = ReminderStateItem.getDoneType(reminderItem.type);

    final Color slideColor;
    final Color backGroundColor;
    final Color innerShadowBackGroundColor;

    if (!reminderItem.enabled) {
      slideColor = AppColors.black50;
      backGroundColor = AppColors.black50;
      innerShadowBackGroundColor = const Color(0xFF8B0E0E).withAlpha(35);
    } else {
      if (percent == 0 && !reminderItem.haveBaseValue) {
        slideColor = AppColors.black50;
        backGroundColor = AppColors.black50;
        innerShadowBackGroundColor = const Color(0xFF8B0E0E).withAlpha(35);
      } else if (percent <= 0.2) {
        slideColor = const Color(0xFFCD3A3A);
        backGroundColor = const Color(0xFFFBEAEA);
        innerShadowBackGroundColor = const Color(0xFF8B0E0E).withAlpha(35);
      } else if (percent <= 0.4) {
        slideColor = AppColors.orange500;
        backGroundColor = AppColors.orange50;
        innerShadowBackGroundColor = const Color(0xFFB3740C).withAlpha(50);
      } else {
        slideColor = const Color(0xFF3C9452);
        backGroundColor = const Color(0xFFDEF9E5);
        innerShadowBackGroundColor = const Color(0xFF0D3417).withAlpha(35);
      }
    }

    return InnerShadow(
      shadows: [
        BoxShadow(
          blurRadius: 6,
          offset: Offset(0, 0),
          color: Colors.black.withAlpha(45),
        ),
      ],
      child: Container(
        width: isHomeScreen ? 110.w : 162.w,

        constraints: BoxConstraints(minHeight: isHomeScreen ? 110.h : 126.h),
        padding: EdgeInsets.only(
          left: 14.w,
          right: 14.w,
          top: 12.h,
          bottom: 17.h,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3F5),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: InnerShadow(
          shadows: [
            BoxShadow(
              blurRadius: 4,
              offset: const Offset(0, 0),
              color: innerShadowBackGroundColor,
            ),
          ],
          child: Column(
            children: [
              if (!isHomeScreen)
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: SizedBox(
                    height: 24.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: farsiTextForType.contains('(')
                                    ? '${farsiTextForType.split('(')[0]}\n'
                                    // before parentheses
                                    : farsiTextForType,
                                style: TextStyle(
                                  color: AppColors.blue500,
                                  fontFamily: "IRANSansXFaNum",
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (farsiTextForType.contains('('))
                                TextSpan(
                                  text:
                                      '(${farsiTextForType.split('(')[1]}', // re-add parentheses
                                  style: TextStyle(
                                    color: AppColors.blue500,
                                    fontFamily: "IRANSansXFaNum",
                                    fontSize:
                                        6.sp, // smaller for inside parentheses
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2, // prevents overflow
                        ),

                        EnableToggle(
                          reminderItem: reminderItem,
                          reminderAction:
                              reminderAction[reminderItem.type] ??
                              () async {
                                appLogger.i("No action.");
                                return false;
                              },
                        ),
                      ],
                    ),
                  ),
                ),
              CircularPercentIndicator(
                radius: isHomeScreen ? 34.r : 50.r,
                lineWidth: 8.w,
                percent: percent,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isHomeScreen
                          ? remainingFormatted
                          : /* remainingValue == 0
                          ? "$remainingValue"
                          :  */ "$remainingFormatted/$intervalFormatted",
                      style: TextStyle(
                        color: slideColor,
                        fontSize: isThousand ? 10.sp : 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      isHomeScreen
                          ? "روز"
                          : "${reminderItem.intervalType.name == IntervalType.KILOMETERS.name ? "کیلومتر" : "روز"} باقی مانده",
                      style: TextStyle(
                        color: slideColor,
                        fontSize: isHomeScreen ? 13.sp : 9.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                progressColor: slideColor,
                backgroundColor: backGroundColor,
                circularStrokeCap: CircularStrokeCap.round,
              ),
              if (isHomeScreen)
                Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: Text(
                    ReminderStateItem.translate(reminderItem.type),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blue500,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                Align(
                  alignment: Alignment.centerLeft,
                  child: DoneToggle(
                    reminderItem: reminderItem,
                    isAdd: doneType == DoneType.add ? true : false,
                    reminderAction:
                        reminderAction[reminderItem.type] ??
                        () async {
                          appLogger.i("No action.");
                        },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
