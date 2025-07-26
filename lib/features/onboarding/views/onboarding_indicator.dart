import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/car_info/config/car_info_config_list.dart';
import 'package:motogen/features/car_info/views/car_info_screen.dart';
import 'package:motogen/features/onboarding/views/personal_info_screen.dart';
import 'package:motogen/features/phone_number/views/enter_phone_number_screen.dart';
import 'package:motogen/features/phone_number/views/validate_code_screen.dart';


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
                //Learn(),
                EnterPhoneNumberScreen(
                  currentPage: _currentPage,
                  count: count,
                  onNext: _nextPage,
                ),
                ValidateCodeScreen(
                  currentPage: _currentPage,
                  count: count,
                  onNext: _nextPage,
                  onBack: _prevPage,
                ),
                PersonalInfoScreen(
                  currentPage: _currentPage,
                  count: count,
                  onNext: _nextPage,
                  onBack: _prevPage,
                ),
                CarInfoScreen(
                  currentPage: _currentPage,
                  count: count,
                  onNext: _nextPage,
                  onBack: _prevPage,
                  carInfoField: carInfoFirstPageFields,
                ),
                CarInfoScreen(
                  currentPage: _currentPage,
                  count: count,
                  onNext: _nextPage,
                  onBack: _prevPage,
                  carInfoField: carInfoSecondPageFields,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
