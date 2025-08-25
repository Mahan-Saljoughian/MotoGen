import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/car_info/views/car_form_screen.dart';
import 'package:motogen/features/car_info/views/car_nickname_screen.dart';
import 'package:motogen/features/user_info/views/personal_info_screen.dart';
import 'package:motogen/features/user_info/views/enter_phone_number_screen.dart';
import 'package:motogen/features/user_info/views/code_confirm_screen.dart';

class OnboardingIndicator extends ConsumerStatefulWidget {
  const OnboardingIndicator({super.key});

  @override
  ConsumerState<OnboardingIndicator> createState() =>
      _OnboardingIndicatorState();
}

class _OnboardingIndicatorState extends ConsumerState<OnboardingIndicator> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int count = 6;

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
                EnterPhoneNumberScreen(
                  currentPage: _currentPage,
                  count: count,
                  onNext: _nextPage,
                ),
                CodeConfirmScreen(
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
                CarFormScreen(
                  mode: CarInfoFormMode.completeProfile,
                  currentPage: _currentPage,
                  count: count,
                  onCompleteProfileNext: _nextPage,
                  onCompleteProfileBack: _prevPage,
                ),
                CarFormScreen(
                  mode: CarInfoFormMode.completeProfile,
                  currentPage: _currentPage,
                  count: count,
                  onCompleteProfileNext: _nextPage,
                  onCompleteProfileBack: _prevPage,
                ),
                CarNicknameScreen(
                  currentPage: _currentPage,
                  count: count,
                  onNext: () =>
                      Navigator.pushReplacementNamed(context, '/mainApp'),

                  onBack: _prevPage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
