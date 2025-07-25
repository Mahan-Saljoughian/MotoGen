import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/views/onboarding/phone_number/validate_code_screen.dart';
import 'package:motogen/views/widgets/onboarding_button.dart';

class OnboardingIndicator extends ConsumerStatefulWidget {
  const OnboardingIndicator({super.key});

  @override
  ConsumerState<OnboardingIndicator> createState() =>
      _OnboardingIndicatorState();
}

class _OnboardingIndicatorState extends ConsumerState<OnboardingIndicator> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int count = 5;

  void _nextPage() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _prevPage() {
    _pageController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (index) => setState(() => _currentPage = index),
              children: [
                /*  PersonalInfoScreen(),
                CarInfoScreen(_prevPage, carInfoFirstPageFields),
                CarInfoScreen(_prevPage, carInfoSecondPageFields),
                //Learn(), 
                EnterPhoneNumberScreen(onBack: _prevPage), */
                ValidateCodeScreen(onBack: _prevPage),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.027,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(count, (index) {
                bool isActive = index <= _currentPage;
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
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.08,
            ),
            child: OnboardingButton(
              ref,
              currentPage: _currentPage,
              onPressed: () => _nextPage(),
            ),
          ),
        ],
      ),
    );
  }
}
