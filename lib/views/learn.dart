import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/views/widgets/onboarding_button.dart';

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
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      color: toggle ? boxColors[0] : boxColors[1],

                      height: 300.h,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      color: toggle ? boxColors[1] : boxColors[0],
                      height: 300.h,
                    ),
                  ),
                ),
              ],
            ),
            onboardingButton(
              text: "عوض کن",
              onPressed: () => setState(() {
                toggle = !toggle;
              }),
            ),
          ],
        ),
      ),
    );
  }
}
