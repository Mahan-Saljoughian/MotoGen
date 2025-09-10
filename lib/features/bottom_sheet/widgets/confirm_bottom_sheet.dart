import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/widgets/my_circular_progress_indicator.dart';

/// Helper to open the ConfirmBottomSheet
Future<bool?> showConfirmBottomSheet({
  required BuildContext context,
  Future<void> Function()? onConfirm,
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

class ConfirmBottomSheet extends ConsumerStatefulWidget {
  final Future<void> Function()? onConfirm;
  final bool isPopOnce;
  final bool isDelete;
  final bool isConfirmDate;
  final bool isConfirmKilometer;
  final bool autoPop;
  final String titleText;

  final String? intervalReminderText;

  const ConfirmBottomSheet({
    super.key,
    this.onConfirm,
    required this.isPopOnce,
    required this.isDelete,
    required this.isConfirmDate,
    required this.isConfirmKilometer,
    required this.autoPop,
    required this.titleText,
    this.intervalReminderText,
  });

  @override
  ConsumerState<ConfirmBottomSheet> createState() => _ConfirmBottomSheetState();
}

class _ConfirmBottomSheetState extends ConsumerState<ConfirmBottomSheet> {
  bool isLoading = false;
  Future<void> _handleConfirmTap(BuildContext context) async {
    if (isLoading) return;

    setState(() => isLoading = true);

    try {
      if (widget.onConfirm != null) {
        await widget.onConfirm!.call();
      } else {
        Navigator.of(context).pop(true);
      }

      if (widget.autoPop && context.mounted) {
        if (widget.isPopOnce) {
          Navigator.of(context).pop(true);
        } else {
          Navigator.of(context)
            ..pop()
            ..pop(true);
        }
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final confirmColor = widget.isDelete
        ? Color(0xFFC60B0B)
        : Color(0xFF3C9452);
    final yesConfirmText = widget.isConfirmDate
        ? "تاریخ قبلی"
        : widget.isConfirmKilometer
        ? "کیلومتر قبلی"
        : "بله";
    final noConfirmText = widget.isConfirmDate
        ? "تاریخ جدید"
        : widget.isConfirmKilometer
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
              widget.titleText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.blue600,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),

            if (widget.intervalReminderText != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 21.h),
                child: Text(
                  widget.intervalReminderText ?? "",
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
                  onTap: isLoading ? null : () => _handleConfirmTap(context),
                  child: Container(
                    height: 48.h,
                    width: 144.w,
                    decoration: BoxDecoration(
                      color: confirmColor,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Center(
                      child: isLoading
                          ? const MyCircularProgressIndicator()
                          : Text(
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
