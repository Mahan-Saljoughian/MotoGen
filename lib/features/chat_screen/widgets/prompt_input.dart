import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';

class PromptInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  const PromptInput({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(
                color: AppColors.blue100,
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "سوالت رو اینجا بپرس...",
                hintStyle: TextStyle(
                  color: AppColors.blue100,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.r),
                  borderSide: BorderSide(
                    color: AppColors.blue100,
                    width: 1.5.w,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.r),
                  borderSide: BorderSide(
                    color: AppColors.blue100,
                    width: 1.5.w,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 17.w,
                  vertical: 10.h,
                ),
              ),
            ),
          ),
          SizedBox(width: 7.w),
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 43.w,
              height: 43.w,
              alignment: Alignment.center,

              decoration: BoxDecoration(
                color: AppColors.blue400,
                borderRadius: BorderRadius.circular(69.r),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.35),
                    offset: Offset(0, 0),
                    blurRadius: 4.61,
                  ),
                ],
              ),
              child: SvgPicture.asset(
                AppIcons.send,
                width: 24.w,
                height: 24.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
