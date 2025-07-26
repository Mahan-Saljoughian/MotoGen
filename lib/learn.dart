import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';


class Learn extends StatefulWidget {
  const Learn({super.key});

  @override
  State<Learn> createState() => _LearnState();
}

class _LearnState extends State<Learn> {
  bool toggle = false;
  List<Color> boxColors = [AppColors.orange400, AppColors.blue400];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.blue600),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 8.w , vertical: 8.h),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    color: toggle ? boxColors[0] : boxColors[1],
      
                    height: 300.h,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 8.w , vertical: 8.h),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    color: toggle ? boxColors[1] : boxColors[0],
                    height: 300.h,
                  ),
                ),
              ),
            ],
          ),
      
          GestureDetector(
            onTap: () {
              setState(() {
                toggle = !toggle;
              });
            },
            child: Container(
              width: 330.w,
              height: 48.w,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.orange600,
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Text(
                "عوض کن",
                style: TextStyle(
                  color: AppColors.black50,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
