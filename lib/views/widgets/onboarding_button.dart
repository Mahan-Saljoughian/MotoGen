import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';

class onboardingButton extends ConsumerWidget {
  final String text;
  final VoidCallback onPressed;
  final bool? enabled;

  const onboardingButton({
    super.key,
    required this.onPressed,
    this.enabled = true,
    required this.text,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: enabled!
          ? /* () async {
              await ref.watch(currentProvider).savePersonalInfo();
              onPressed();
            } */ onPressed
          : null,
      child: Container(
        width: 330.w,
        height: 48.w,
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: enabled! ? AppColors.orange600 : AppColors.white700,
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.black50,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
