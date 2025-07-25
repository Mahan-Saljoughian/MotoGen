import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/viewmodels/car_info/car_info_form_viewmodel.dart';
import 'package:motogen/viewmodels/personal_info_controller_view_model.dart';
import 'package:motogen/viewmodels/phone_number_controller_view_model.dart';
import 'package:motogen/views/onboarding/car_info/picker_item.dart';

class OnboardingButton extends ConsumerWidget {
  final WidgetRef ref;
  final int currentPage;
  final VoidCallback onPressed;

  OnboardingButton(
    this.ref, {
    super.key,
    required this.onPressed,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: _getCurrentButtonEnabled()
          ? /* () async {
              await ref.watch(currentProvider).savePersonalInfo();
              onPressed();
            } */ onPressed
          : null,
      child: Container(
        width: 330.w,
        height: 48.w,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: _getCurrentButtonEnabled()
              ? AppColors.orange600
              : AppColors.white700,
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

  bool _getCurrentButtonEnabled() {
    switch (currentPage) {
      case 0:
        return ref.watch(personalInfoProvider).isButtonEnabled;
      case 1:
        return ref.watch(isCarInfoButtonEnabledForFirstPageProvider);
      case 2:
        return ref.watch(isCarInfoButtonEnabledForSecondPageProvider);
      case 3:
        return ref.watch(phoneNumberControllerProvider).isValid;
      default:
        return false;
    }
  }

  final isCarInfoButtonEnabledForFirstPageProvider = Provider<bool>((ref) {
    final state = ref.watch(carInfoFormProvider);
    final hasBrand =
        state.brand != null && state.brand != PickerItem.noValueString;
    final hasModel =
        state.model != null && state.model != PickerItem.noValueString;
    final hasType =
        state.type != null && state.type != PickerItem.noValueString;
    final hasYear = state.yearMade != null && state.yearMade != -1;
    final hasColor = state.color != null;

    // add other fields if needed

    return hasBrand && hasModel && hasType && hasYear && hasColor;
  });

  final isCarInfoButtonEnabledForSecondPageProvider = Provider<bool>((ref) {
    final state = ref.watch(carInfoFormProvider);

    final rawKm = state.rawKilometersInput ?? '';
    final parsedKm = int.tryParse(rawKm);

    final isKmValid = parsedKm != null && parsedKm > 0 && parsedKm < 10000000;

    return isKmValid &&
        state.fuelType !=
            null /* &&
        state.insuranceExpiry != null &&
        state.nextTechnicalCheck != null */;
  });

  String _getCurrentButtonText() {
    switch (currentPage) {
      case 0:
      case 1:
      case 2:
        return "تایید و ادامه";
      case 3:
        return "دریافت کد تایید";
      case 4:
        return "ورود";
      default:
        return "تایید و ادامه";
    }
  }
}
