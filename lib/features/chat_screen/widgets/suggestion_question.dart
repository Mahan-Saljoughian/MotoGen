import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';

class SuggestionQuestion extends ConsumerWidget {
  final String prompt;
  final VoidCallback onPressed;
  const SuggestionQuestion({
    super.key,
    required this.prompt,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: AppColors.blue50,
          borderRadius: BorderRadius.circular(60.23.r),
        ),
        child: Text(
          prompt,
          style: TextStyle(
            color: AppColors.blue500,
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
