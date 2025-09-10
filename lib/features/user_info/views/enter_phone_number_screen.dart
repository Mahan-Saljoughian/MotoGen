import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/web.dart';

import 'package:motogen/core/constants/app_colors.dart';

import 'package:motogen/core/constants/app_images.dart';
import 'package:motogen/core/services/farsi_or_english_digits_input_formatter.dart';

import 'package:motogen/features/user_info/model/auth_state.dart';
import 'package:motogen/features/user_info/viewmodels/auth_notifier.dart';
import 'package:motogen/features/user_info/viewmodels/phone_number_controller_view_model.dart';
import 'package:motogen/features/onboarding/widgets/dot_indicator.dart';
import 'package:motogen/widgets/field_text.dart';
import 'package:motogen/features/onboarding/widgets/onboarding_button.dart';
import 'package:motogen/widgets/my_app_bar.dart';

class EnterPhoneNumberScreen extends ConsumerWidget {
  final int currentPage;
  final int count;
  final VoidCallback onNext;

  const EnterPhoneNumberScreen({
    super.key,
    required this.currentPage,
    required this.count,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(authProvider, (prev, next) {
      if (prev?.status != AuthStatus.codeSent &&
          next.status == AuthStatus.codeSent) {
        Logger().d("debug the send code is : ${next.codeSent}");
        onNext();
      }
    });

    final phoneVm = ref.watch(phoneNumberControllerProvider);
    final auth = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);
    final loading = ref.watch(authProvider).status == AuthStatus.loading;

    final phoneNumberString =
        FarsiOrEnglishDigitsInputFormatter.normalizePersianDigits(
          phoneVm.phoneController.text.trim(),
        );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Center(
            child: Column(
              children: [
                MyAppBar(titleText: "حساب کاربری"),

                SizedBox(height: MediaQuery.of(context).size.height * 0.30.h),

                Text(
                  "برای ورود یا ایجاد حساب کاربری شماره موبایلت رو وارد کن...",
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
                    controller: phoneVm.phoneController,
                    isValid: phoneVm.isValid,
                    labelText: "شماره موبایل",
                    hintText: "09123456789",
                    error: auth.message ?? phoneVm.error,
                    isPhone: true,
                    isNumberOnly: true,
                    isShowNeededIcon: false,
                    isBackError: auth.status == AuthStatus.error,
                  ),
                ),

                Image.asset(
                  AppImages.phoneNumberPageImage,
                  width: 250.w,
                  height: 250.w,
                ),

                SizedBox(height: 28.h),
                DotIndicator(currentPage: currentPage, count: count),
                SizedBox(height: 24.h),
                OnboardingButton(
                  currentPage: currentPage,
                  loading: loading,
                  onPressed: () async {
                    await authNotifier.requestOtp(phoneNumberString);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
