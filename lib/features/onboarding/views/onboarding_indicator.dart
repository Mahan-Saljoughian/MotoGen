import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/car_info/views/car_form_screen.dart';
import 'package:motogen/features/onboarding/views/car_nickname_screen.dart';
import 'package:motogen/features/user_info/views/personal_info_screen.dart';
import 'package:motogen/features/user_info/views/enter_phone_number_screen.dart';
import 'package:motogen/features/user_info/views/code_confirm_screen.dart';

class OnboardingIndicator extends ConsumerStatefulWidget {
  final bool skipPhoneStep;
  const OnboardingIndicator({super.key, this.skipPhoneStep = false});

  @override
  ConsumerState<OnboardingIndicator> createState() =>
      _OnboardingIndicatorState();
}

class _OnboardingIndicatorState extends ConsumerState<OnboardingIndicator> {
  late final PageController _pageController;
  late int _logicalPage;
  final int fullCount = 6;

  @override
  void initState() {
    super.initState();
    _logicalPage = widget.skipPhoneStep ? 2 : 0;

    _pageController = PageController(initialPage: 0);
  }

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
    final List<Widget> pages = [];

    if (!widget.skipPhoneStep) {
      pages.addAll([
        EnterPhoneNumberScreen(
          currentPage: _logicalPage,
          count: fullCount,
          onNext: _nextPage,
        ),
        CodeConfirmScreen(
          currentPage: _logicalPage,
          count: fullCount,
          onNext: _nextPage,
          onBack: _prevPage,
        ),
      ]);
    }

    pages.addAll([
      PersonalInfoScreen(
        currentPage: _logicalPage,
        count: fullCount,
        onNext: _nextPage,
        onBack: widget.skipPhoneStep ? null : _prevPage,
      ),
      CarFormScreen(
        mode: CarInfoFormMode.completeProfile,
        currentPage: _logicalPage,
        count: fullCount,
        onCompleteProfileNext: _nextPage,
        onCompleteProfileBack: _prevPage,
      ),
      CarFormScreen(
        mode: CarInfoFormMode.completeProfile,
        currentPage: _logicalPage,
        count: fullCount,
        onCompleteProfileNext: _nextPage,
        onCompleteProfileBack: _prevPage,
      ),
      CarNicknameScreen(
        currentPage: _logicalPage,
        count: fullCount,
        onNext: () => Navigator.pushReplacementNamed(context, '/mainApp'),

        onBack: _prevPage,
      ),
    ]);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (physicalIndex) {
                setState(() {
                  _logicalPage = widget.skipPhoneStep
                      ? physicalIndex + 2
                      : physicalIndex;
                });
              },
              children: pages,
            ),
          ),
        ],
      ),
    );
  }
}
