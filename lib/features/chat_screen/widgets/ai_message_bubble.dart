import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';

class AiMessageBubble extends StatelessWidget {
  final String aiMessage;
  const AiMessageBubble({super.key, required this.aiMessage});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 17.h),
        child: Row(
          children: [
            SizedBox(width: 23.w),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 0.6.sw),
                  padding: EdgeInsets.only(
                    top: 7.h,
                    bottom: 7.h,
                    right: 16.w,
                    left: 16.w,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.blue400,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.r),
                      topRight: Radius.circular(15.r),
                      bottomLeft: Radius.circular(3.r),
                      bottomRight: Radius.circular(15.r),
                    ),
                  ),
                  child: Text(
                    aiMessage,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Color(0xFFF7FBF1),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                      height: 2.h,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: -4,
                  child: SvgPicture.asset(
                    AppIcons.blueTail,
                    width: 20.w,
                    height: 14.h,
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
