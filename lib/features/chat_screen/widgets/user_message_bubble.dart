import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';

class UserMessageBubble extends StatelessWidget {
  final String textMessage;
  const UserMessageBubble({super.key, required this.textMessage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 17.h),
      child: Row(
        children: [
          SizedBox(width: 23.w),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 0.55.sw),
                padding: EdgeInsets.only(
                  top: 7.h,
                  bottom: 7.h,
                  left: 13.w,
                  right: 13.w,
                ),
                decoration: BoxDecoration(
                  color: AppColors.blue50,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.r),
                    topRight: Radius.circular(15.r),
                    bottomLeft: Radius.circular(15.r),
                    bottomRight: Radius.circular(3.r),
                  ),
                ),
                child: Text(
                  textMessage,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.blue500,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                    height: 2.h,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: -4,
                child: SvgPicture.asset(
                  AppIcons.whiteTail,
                  width: 20.w,
                  height: 14.h,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
