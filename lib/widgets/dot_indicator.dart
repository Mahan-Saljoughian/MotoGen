import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';

class DotIndicator extends StatelessWidget {
  final int currentPage;
  final int count;
  const DotIndicator({
    super.key,
    required this.currentPage,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        bool isActive = index <= currentPage;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: isActive ? AppColors.orange500 : AppColors.black100,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
