import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';

/// Helper to open the ConfirmBottomSheet
Future<void> showConfirmBottomSheet({
  required BuildContext context,
  required Future<void> Function() onConfirm,
  VoidCallback? onReset,
  bool isDelete = false,
}) {
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
    ),
    builder: (_) => ConfirmBottomSheet(
      onConfirm: onConfirm,
      onReset: onReset,
      isDelete: isDelete,
    ),
  );
}

class ConfirmBottomSheet extends ConsumerWidget {
  final Future<void> Function() onConfirm;
  final VoidCallback? onReset;
  final bool isDelete;
  const ConfirmBottomSheet({
    super.key,
    required this.onConfirm,
    this.onReset,
    required this.isDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final confirmText = isDelete
        ? "برای حذف کردنش مطمئنی؟"
        : "از ویرایش جدیدت مطمئنی؟";
    final confirmColor = isDelete ? Color(0xFFC60B0B) : Color(0xFF3C9452);
    return SizedBox(
      height: 178.h,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 51.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              confirmText,
              style: TextStyle(
                color: AppColors.blue600,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    await onConfirm();
                    onReset?.call();

                    if (context.mounted) {
                      if (onReset != null) {
                        Navigator.of(context)
                          ..pop()
                          ..pop();
                      } else {
                        Navigator.of(context).pop();
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
                        "بله",
                        style: TextStyle(
                          color: AppColors.black50,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    if (context.mounted) {
                      Navigator.of(context).pop();
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
                        "خیر",
                        style: TextStyle(
                          color: confirmColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0,
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
