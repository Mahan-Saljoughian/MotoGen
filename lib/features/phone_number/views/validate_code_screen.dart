import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/core/constants/app_images.dart';
import 'package:motogen/features/phone_number/data/auth_notifier.dart';
import 'package:motogen/features/phone_number/model/auth_state.dart';
import 'package:motogen/features/phone_number/viewmodels/code_controller_view_model.dart';
import 'package:motogen/features/onboarding/widgets/dot_indicator.dart';
import 'package:motogen/features/onboarding/widgets/onboarding_button.dart';


class ValidateCodeScreen extends ConsumerStatefulWidget {
  final int currentPage;
  final int count;
  final VoidCallback onNext;
  final VoidCallback onBack;
  const ValidateCodeScreen({
    super.key,
    required this.currentPage,
    required this.count,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<ValidateCodeScreen> createState() => _ValidateCodeScreenState();
}

class _ValidateCodeScreenState extends ConsumerState<ValidateCodeScreen> {
  late final List<TextEditingController> controllers;
  late final List<FocusNode> focusNodes;
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    final digits = ref.read(codeControllerProvider).digits;
    controllers = List.generate(
      4,
      (i) => TextEditingController(text: digits[i]),
    );
    focusNodes = List.generate(4, (_) => FocusNode());

    //start the timer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(codeControllerProvider.notifier).startTimer();
      focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (prev, next) {
      if (prev?.status != AuthStatus.confirmed &&
          next.status == AuthStatus.confirmed) {
        widget.onNext();
      }
    });

    final codeVM = ref.watch(codeControllerProvider);
    final auth = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);
    final bool hasError = auth.status == AuthStatus.error;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Center(
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 20.w),
                      GestureDetector(
                        onTap: () {
                          codeVM.cancelTimer();
                          codeVM.resetCode();
                          widget.onBack();
                        },
                        child: SvgPicture.asset(
                          AppIcons.arrowRight,
                          width: 24.w,
                          height: 24.h,
                        ),
                      ),
                      SizedBox(width: 110.w),
                      Text(
                        "حساب کاربری",
                        style: TextStyle(
                          color: AppColors.blue500,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 224.h),
                  Text(
                    "کد تایید پیامک شده به موبایلت رو وارد کن...",
                    style: TextStyle(
                      color: AppColors.blue900,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 25.h),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        4,
                        (i) => Container(
                          width: 46.w,
                          height: 46.w,
                          margin: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: hasError
                                  ? Color(0xffC60B0B)
                                  : AppColors.blue500,
                              width: 1.5.w,
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: TextField(
                            controller: controllers[i],
                            focusNode: focusNodes[i],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: hasError
                                  ? Color(0xffC60B0B)
                                  : AppColors.blue500,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(1),
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              if (value.length == 1 && i < 3) {
                                focusNodes[i + 1].requestFocus();
                              }
                              if (value.isEmpty && i > 0) {
                                focusNodes[i - 1].requestFocus();
                              }

                              ref
                                  .read(codeControllerProvider.notifier)
                                  .updateDigit(i, value);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 17.h),
                  hasError
                      ? Text(
                          auth.message ?? "کدی که وارد کردی اشتباهه!",
                          style: TextStyle(
                            color: Color(0xffC60B0B),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : Text(
                          codeVM.timerText,
                          style: TextStyle(
                            color: AppColors.blue900,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                  SizedBox(height: 17.h),
                  GestureDetector(
                    onTap: () {
                      final phone = auth.phoneNumber;
                      if (phone != null && phone.isNotEmpty) {
                        authNotifier.requestOtp(phone);
                        Logger().d("debug the send code is : ${auth.codeSent}");
                      } else {
                        logger.d("Phone number is missing!");
                      }
                      ref.read(codeControllerProvider.notifier).resetCode();
                      for (var controller in controllers) {
                        controller.clear();
                      }
                      ref.read(codeControllerProvider.notifier).startTimer();
                      focusNodes[0].requestFocus();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 134.w),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            AppIcons.rotateLeft,
                            height: 24.h,
                            width: 24.w,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            "ارسال مجدد کد",
                            style: TextStyle(
                              color: Color(0xFF3D89F6),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Image.asset(
                    AppImages.phoneCodePageImage,
                    width: 276.w,
                    height: 276.w,
                  ),
                  SizedBox(height: 13.h),
                  DotIndicator(
                    currentPage: widget.currentPage,
                    count: widget.count,
                  ),
                  SizedBox(height: 24.h),
                  OnboardingButton(
                    currentPage: widget.currentPage,
                    onPressed: () {
                      final codeVM = ref.read(codeControllerProvider);
                      if (codeVM.isComplete &&
                          codeVM.isTimerActive &&
                          auth.status != AuthStatus.loading &&
                          auth.status != AuthStatus.confirmed) {
                        final phone = auth.phoneNumber;
                        if (phone != null && phone.isNotEmpty) {
                          authNotifier.confirmOtp(phone, codeVM.code);
                        } else {
                          logger.d("Phone number is missing!");
                        }
                      }
                    },
                    enabled:
                        codeVM.isComplete &&
                        codeVM.isTimerActive &&
                        auth.status != AuthStatus.loading,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
