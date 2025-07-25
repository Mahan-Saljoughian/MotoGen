import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:motogen/core/constants/app_images.dart';
import 'package:motogen/viewmodels/code_controller_view_model.dart';

class ValidateCodeScreen extends ConsumerWidget {
  final VoidCallback onBack;
  const ValidateCodeScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codeVM = ref.watch(codeControllerProvider);

    final controllers = List.generate(
      4,
      (i) => TextEditingController(
        text: ref.read(codeControllerProvider).digits[i],
      ),
    );
    final focusNodes = List.generate(4, (_) => FocusNode());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding:  EdgeInsets.symmetric(vertical: 20.h),
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: onBack,
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
                  ),
                  SizedBox(height: 238.h),
                  Text(
                    "کد تایید پیامک شده به موبایلت رو وارد کن...",
                    style: TextStyle(
                      color: AppColors.blue900,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 36.h),

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
                              color: AppColors.blue500,
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
                              color: AppColors.blue500,
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

                              /*    /*    ref
                                  .read(codeControllerProvider.notifier)
                                  .updateDigit(i, value); */ */
                              if (codeVM.isComplete) {
                                print("[DEBUG] ${codeVM.code}");
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Image.asset(
                    AppImages.phoneCodePageImage,
                    width: 250.w,
                    height: 250.w,
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
