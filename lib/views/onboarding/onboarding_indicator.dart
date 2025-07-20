import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/viewmodels/personal_info_view_model.dart';
import 'package:motogen/views/learn.dart';
import 'package:motogen/views/onboarding/onboarding_page_1.dart';
import 'package:motogen/views/onboarding/personal_info_screen.dart';
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

  ProviderBase<dynamic> _getCurrentStepProvider() {
    switch (_currentPage) {
      case 0:
        return personalInfoProvider;
      // case 1: return carProvider;
      // case 2: return phoneProvider;
      default:
        return personalInfoProvider;
    }
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: Duration(microseconds: 300),
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
              children: [PersonalInfoScreen(), Learn()],
            ),
          ),

          /*  Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.027,
            ),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: 5,
              effect: WormEffect(
                dotHeight: 8.h,
                dotWidth: 8.w,
                dotColor: AppColors.black100,
                spacing: 8,
                activeDotColor: AppColors.orange500,
              ),
            ),
          ), */
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
            child: onboardingButton(
              text: "تایید و ادامه",
              onPressed: () => _nextPage(),
              currentProvider: _getCurrentStepProvider(),
            ),
          ),
        ],
      ),
    );
  }
}
