import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/features/car_info/viewmodels/car_info_form_viewmodel.dart';
import 'package:motogen/features/car_info/viewmodels/date_input_view_model.dart';
import 'package:motogen/features/car_info/viewmodels/nick_name_validator.dart';
import 'package:motogen/features/onboarding/viewmodels/personal_info_controller_view_model.dart';

import 'package:motogen/features/phone_number/viewmodels/phone_number_controller_view_model.dart';
import 'package:motogen/features/car_info/config/picker_item.dart';

final isCarInfoButtonEnabledForFirstPageProvider = Provider<bool>((ref) {
  final state = ref.watch(carInfoFormProvider);
  final hasBrand =
      state.brand != null && state.brand != PickerItem.noValueString;
  final hasModel =
      state.model != null && state.model != PickerItem.noValueString;
  final hasType = state.type != null && state.type != PickerItem.noValueString;
  final hasYear = state.yearMade != null && state.yearMade != -1;
  final hasColor = state.color != null;

  return hasBrand && hasModel && hasType && hasYear && hasColor;
});

final isCarInfoButtonEnabledForSecondPageProvider = Provider<bool>((ref) {
  final state = ref.watch(carInfoFormProvider);

  final rawKm = state.rawKilometersInput ?? '';
  final parsedKm = int.tryParse(rawKm);

  final isKmValid = parsedKm != null && parsedKm > 0 && parsedKm < 10000000;

  return isKmValid &&
      state.fuelType != null &&
      state.insuranceExpiry != null &&
      state.nextTechnicalCheck != null;
});

class OnboardingButton extends ConsumerWidget {
  final int currentPage;
  final VoidCallback onPressed;
  final bool? enabled;

  const OnboardingButton({
    super.key,
    required this.onPressed,
    required this.currentPage,
    this.enabled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonEnabled = enabled ?? _getCurrentButtonEnabled(ref);
    return GestureDetector(
      onTap: buttonEnabled ? onPressed : null,
      child: Container(
        width: 330.w,
        height: 48.w,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: buttonEnabled ? AppColors.orange600 : AppColors.white700,
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Text(
          _getCurrentButtonText(),
          style: TextStyle(
            color: AppColors.black50,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  bool _getCurrentButtonEnabled(WidgetRef ref) {
    switch (currentPage) {
      case 0:
        return ref.watch(phoneNumberControllerProvider).isValid;
      case 2:
        return ref.watch(personalInfoProvider).isButtonEnabled;
      case 3:
        return ref.watch(isCarInfoButtonEnabledForFirstPageProvider);
      case 4:
        return ref.watch(isCarInfoButtonEnabledForSecondPageProvider);
      case 5:
        return ref.watch(nickNameValidatorProvider).isNickNameValid;
      case 10:
        return ref.watch(dateInputProvider).isDateValid;

      default:
        return false;
    }
  }

  String _getCurrentButtonText() {
    switch (currentPage) {
      case 0:
        return "دریافت کد تایید";
      case 1:
        return "ورود";
      case 2:
      case 3:
      case 4:
        return "تایید و ادامه";
      case 5:
        return "ورود به برنامه";
      case 10:
        return "تایید";
      default:
        return "تایید و ادامه";
    }
  }
}
