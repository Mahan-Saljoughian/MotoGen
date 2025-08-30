import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';

/// Helper to open the ConfirmBottomSheet
Future<bool?> showConfirmBottomSheet({
  required BuildContext context,
  required Future<void> Function() onConfirm,
  bool isPopOnce = false,
  bool isDelete = false,
  bool isConfirmDate = false,
  bool isConfirmKilometer = false,
  bool autoPop = true,
  required String titleText,
  String? intervalReminderText,
}) {
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
    ),
    builder: (_) => ConfirmBottomSheet(
      onConfirm: onConfirm,
      isPopOnce: isPopOnce,
      isDelete: isDelete,
      isConfirmDate: isConfirmDate,
      isConfirmKilometer: isConfirmKilometer,
      autoPop: autoPop,
      titleText: titleText,

      intervalReminderText: intervalReminderText ?? "",
    ),
  );
}

class ConfirmBottomSheet extends ConsumerWidget {
  final Future<void> Function() onConfirm;
  final bool isPopOnce;
  final bool isDelete;
  final bool isConfirmDate;
  final bool isConfirmKilometer;
  final bool autoPop;
  final String titleText;

  final String? intervalReminderText;
  const ConfirmBottomSheet({
    super.key,
    required this.onConfirm,
    required this.isPopOnce,
    required this.isDelete,

    required this.isConfirmDate,
    required this.isConfirmKilometer,
    required this.autoPop,
    required this.titleText,
    this.intervalReminderText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final confirmColor = isDelete ? Color(0xFFC60B0B) : Color(0xFF3C9452);
    final yesConfirmText = isConfirmDate
        ? "تاریخ قبلی"
        : isConfirmKilometer
        ? "کیلومتر قبلی"
        : "بله";
    final noConfirmText = isConfirmDate
        ? "تاریخ جدید"
        : isConfirmKilometer
        ? "کیلومتر جدید"
        : "خیر";

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.3,
      ),
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 51.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [
            Text(
              titleText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.blue600,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),

            if (intervalReminderText != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 21.h),
                child: Text(
                  intervalReminderText ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.blue300,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    await onConfirm();

                    if (autoPop && context.mounted) {
                      if (isPopOnce) {
                        Navigator.of(context).pop(true);
                      } else {
                        Navigator.of(context)
                          ..pop()
                          ..pop(true);
                      }
                    }
                  },
                  child: Container(
                    height: 48.h,
                    width: 144.w,
                    decoration: BoxDecoration(
                      color: confirmColor,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Center(
                      child: Text(
                        yesConfirmText,
                        style: TextStyle(
                          color: AppColors.black50,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    if (context.mounted) {
                      Navigator.of(context).pop(false);
                    }
                  },
                  child: Container(
                    height: 48.h,
                    width: 144.w,
                    decoration: BoxDecoration(
                      color: AppColors.black50,
                      borderRadius: BorderRadius.circular(50.r),
                      border: Border.all(color: confirmColor),
                    ),
                    child: Center(
                      child: Text(
                        noConfirmText,
                        style: TextStyle(
                          color: confirmColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
