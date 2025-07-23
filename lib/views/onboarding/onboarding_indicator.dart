import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/viewmodels/car_info/car_info_form_viewmodel.dart';
import 'package:motogen/viewmodels/personal_info_view_model.dart';
import 'package:motogen/views/learn.dart';
import 'package:motogen/views/onboarding/car_info/car_info_screen.dart';
import 'package:motogen/views/onboarding/car_info/first_car_info_config.dart';
import 'package:motogen/views/onboarding/car_info/second_car_info_config.dart';
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

  final isCarInfoButtonEnabledForFirstPageProvider = Provider<bool>((ref) {
    final state = ref.watch(CarInfoFormProvider);
    return state.brand != null &&
        state.model != null &&
        state.type != null &&
        state.yearMade != null &&
        state.color != null;
  });

  final isCarInfoButtonEnabledForSecondPageProvider = Provider<bool>((ref) {
    final state = ref.watch(CarInfoFormProvider);

    final rawKm = state.rawKilometersInput ?? '';
    final parsedKm = int.tryParse(rawKm);

    final isKmValid = parsedKm != null && parsedKm > 0 && parsedKm < 10000000;

    return isKmValid &&
        state.fuelType !=
            null /* &&
        state.insuranceExpiry != null &&
        state.nextTechnicalCheck != null */;
  });

  bool _getCurrentButtonEnabled() {
    switch (_currentPage) {
      case 0:
        return ref.watch(personalInfoProvider).isButtonEnabled;
      case 1:
        return ref.watch(isCarInfoButtonEnabledForFirstPageProvider);
      case 2:
        return ref.watch(isCarInfoButtonEnabledForSecondPageProvider);
      default:
        return false;
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
              children: [
                PersonalInfoScreen(),
                CarInfoScreen(_prevPage, carInfoFirstPageFields),
                CarInfoScreen(_prevPage, carInfoSecondPageFields),
                Learn(),
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
            child: onboardingButton(
              text: "تایید و ادامه",
              onPressed: () => _nextPage(),
              enabled: _getCurrentButtonEnabled(),
            ),
          ),
        ],
      ),
    );
  }
}
