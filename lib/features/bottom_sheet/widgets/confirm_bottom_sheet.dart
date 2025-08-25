import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';

/// Helper to open the ConfirmBottomSheet
Future<void> showConfirmBottomSheet({
  required BuildContext context,
  required Future<void> Function() onConfirm,
  bool isPopOnce = false,
  bool isDelete = false,
  required String titleText,
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
      titleText: titleText,
    ),
  );
}

class ConfirmBottomSheet extends ConsumerWidget {
  final Future<void> Function() onConfirm;
  final bool isPopOnce;
  final bool isDelete;
  final String titleText;
  const ConfirmBottomSheet({
    super.key,
    required this.onConfirm,
    required this.isPopOnce,
    required this.isDelete,
    required this.titleText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              titleText,
              style: TextStyle(
                color: AppColors.blue600,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    await onConfirm();

                    if (context.mounted) {
                      if (isPopOnce) {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context)
                          ..pop()
                          ..pop();
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
