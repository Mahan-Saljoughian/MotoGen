import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_images.dart';
import 'package:motogen/features/car_info/viewmodels/car_draft_setters.dart';
import 'package:motogen/features/car_info/viewmodels/car_use_case_api.dart';
import 'package:motogen/features/car_info/viewmodels/car_state_notifier.dart';
import 'package:motogen/features/car_info/viewmodels/car_validation.dart';
import 'package:motogen/features/user_info/viewmodels/personal_info_controller_view_model.dart';
import 'package:motogen/features/onboarding/widgets/dot_indicator.dart';
import 'package:motogen/widgets/field_text.dart';
import 'package:motogen/features/onboarding/widgets/onboarding_button.dart';
import 'package:motogen/widgets/my_app_bar.dart';

class CarNicknameScreen extends ConsumerStatefulWidget {
  final int currentPage;
  final int count;
  final VoidCallback onNext;
  final VoidCallback onBack;
  const CarNicknameScreen({
    super.key,
    required this.currentPage,
    required this.count,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<CarNicknameScreen> createState() => _CarNicknameScreenState();
}

class _CarNicknameScreenState extends ConsumerState<CarNicknameScreen> {
  bool _isBusy = false;
  String? _loadingButton;
  Future<void> _handleAction({
    required String buttonKey,
    required bool isSetNickName,
    required VoidCallback onNext,
  }) async {
    if (_isBusy) return;
    setState(() {
      _isBusy = true;
      _loadingButton = buttonKey;
    });

    try {
      final personalInfocontroller = ref.read(personalInfoProvider);
      final draft = ref.read(carDraftProvider);
      await ref
          .read(carStateNotifierProvider.notifier)
          .completeProfileFromDraft(
            isSetNickName: isSetNickName,
            draft: draft,
            userInfo: {
              'firstName': personalInfocontroller.nameController.text.trim(),
              'lastName': personalInfocontroller.lastNameController.text.trim(),
            },
          );
      onNext();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context.mounted ? context : context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
        Navigator.pushReplacementNamed(
          context.mounted ? context : context,
          '/onboardingIndicator',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isBusy = false;
          _loadingButton = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final nickNameController = ref.watch(nickNameControllerProvider);

    final currentCar = ref.watch(carDraftProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Center(
            child: Column(
              children: [
                MyAppBar(
                  titleText: "مشخصات خودرو",
                  ontapFunction: widget.onBack,
                  isBack: true,
                ),

                SizedBox(height: 108.h),
                Text(
                  "ماشینت رو چی صدا میکنی؟ \n لقبش رو اینجا بنویس...",
                  style: TextStyle(
                    color: AppColors.blue900,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 36.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: FieldText(
                    controller: nickNameController,
                    isValid: currentCar.isNickNameValid,
                    labelText: "لقب",
                    hintText: "رخش",
                    isShowNeededIcon: false,
                    error: currentCar.nickNameError,
                    onChanged: (val) => ref.setNickName(val),
                  ),
                ),

                Image.asset(
                  AppImages.nickNameCarPage,
                  width: 260.w,
                  height: 260.w,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.09.h),

                DotIndicator(
                  currentPage: widget.currentPage,
                  count: widget.count,
                ),
                SizedBox(height: 24.h),
                OnboardingButton(
                  currentPage: widget.currentPage,
                  loading: _loadingButton == 'save',
                  onPressed: _isBusy
                      ? null
                      : () => _handleAction(
                          buttonKey: 'save',
                          isSetNickName: true,
                          onNext: widget.onNext,
                        ),
                ),
                SizedBox(height: 20.h),
                OnboardingButton(
                  pagesTitleEnum: PagesTitleEnum.skipNickName,
                  loading: _loadingButton == 'skip',
                  onPressed: _isBusy
                      ? null
                      : () => _handleAction(
                          buttonKey: 'skip',
                          isSetNickName: false,
                          onNext: widget.onNext,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
