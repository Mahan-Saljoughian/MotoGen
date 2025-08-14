import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/services/farsi_or_english_digits_input_formatter.dart';
import 'package:motogen/features/bottom_sheet/config/date_field_config.dart';
import 'package:motogen/features/car_info/viewmodels/car_state_notifier.dart';
import 'package:motogen/features/bottom_sheet/viewmodels/date_input_view_model.dart';
import 'package:motogen/features/car_info/viewmodels/nick_name_validator.dart';
import 'package:motogen/features/user_info/viewmodels/code_controller_view_model.dart';
import 'package:motogen/features/user_info/viewmodels/personal_info_controller_view_model.dart';
import 'package:motogen/features/user_info/viewmodels/phone_number_controller_view_model.dart';
import 'package:motogen/features/bottom_sheet/config/picker_item.dart';

final isCarInfoButtonEnabledForFirstPageProvider = Provider<bool>((ref) {
  final state = ref.watch(carStateNotifierProvider);
  final selectedCar = state.currentCar;
  if (selectedCar == null) return false;
  final hasBrand =
      selectedCar.brand != null &&
      selectedCar.brand != PickerItem.noValueString;
  final hasModel =
      selectedCar.model != null &&
      selectedCar.model != PickerItem.noValueString;
  final hasType =
      selectedCar.type != null && selectedCar.type != PickerItem.noValueString;
  final hasYear = selectedCar.yearMade != null && selectedCar.yearMade != -1;
  final hasColor = selectedCar.color != null;

  return hasBrand && hasModel && hasType && hasYear && hasColor;
});

final isCarInfoButtonEnabledForSecondPageProvider = Provider<bool>((ref) {
  final state = ref.watch(carStateNotifierProvider);
  final selectedCar = state.currentCar;
  if (selectedCar == null) return false;
  final rawKm = selectedCar.rawKilometersInput ?? '';
  final normalizedKm =
      FarsiOrEnglishDigitsInputFormatter.normalizePersianDigits(rawKm);
  final parsedKm = int.tryParse(normalizedKm);

  final isKmValid = parsedKm != null && parsedKm > 0 && parsedKm < 10000000;

  return isKmValid &&
      selectedCar.fuelType != null &&
      selectedCar.thirdPartyInsuranceExpiry != null &&
      selectedCar.nextTechnicalCheck != null;
});

enum PagesTitleEnum {
  repairInfo,
  skipNickName,
  dateBottomSheetInsurance,
  dateBottomSheetServices,
}

class OnboardingButton extends ConsumerWidget {
  final int? currentPage;
  final VoidCallback onPressed;
  final bool? enabled;
  final String? text;
  final PagesTitleEnum? pagesTitleEnum;
  const OnboardingButton({
    super.key,
    required this.onPressed,
    this.currentPage,
    this.enabled,
    this.pagesTitleEnum,
    this.text,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonEnabled = currentPage != null
        ? _getCurrentButtonEnabledWithCurrentPage(ref)
        : pagesTitleEnum != null
        ? _getCurrentButtonEnabledWithPagesTitleEnum(ref)
        : (enabled ?? false);

    final buttonText = currentPage != null
        ? _getCurrentButtonTextWithCurrentPage()
        : pagesTitleEnum != null
        ? _getCurrentButtonTextWithPagesTitleEnum()
        : text ?? "pick a text";
    final Color textColor = pagesTitleEnum == PagesTitleEnum.skipNickName
        ? AppColors.orange600
        : AppColors.black50;
    final Color buttonBackgroundColor =
        pagesTitleEnum == PagesTitleEnum.skipNickName
        ? AppColors.orange50
        : AppColors.orange600;
    final Color borderColor = pagesTitleEnum == PagesTitleEnum.skipNickName
        ? AppColors.orange600
        : Colors.transparent;

    return GestureDetector(
      onTap: buttonEnabled ? onPressed : null,
      child: Container(
        width: 330.w,
        height: 48.w,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: buttonEnabled ? buttonBackgroundColor : AppColors.white700,
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            color: textColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  bool _getCurrentButtonEnabledWithCurrentPage(WidgetRef ref) {
    switch (currentPage) {
      case 0:
        return ref.watch(phoneNumberControllerProvider).isValid;
      case 1:
        return ref.watch(codeControllerProvider).isComplete;
      case 2:
        return ref.watch(personalInfoProvider).isButtonEnabled;
      case 3:
        return ref.watch(isCarInfoButtonEnabledForFirstPageProvider);
      case 4:
        return ref.watch(isCarInfoButtonEnabledForSecondPageProvider);
      case 5:
        return ref.watch(nickNameValidatorProvider).isNickNameValid;
      default:
        return false;
    }
  }

  bool _getCurrentButtonEnabledWithPagesTitleEnum(WidgetRef ref) {
    switch (pagesTitleEnum) {
      case PagesTitleEnum.dateBottomSheetInsurance:
        return ref
            .watch(dateInputProvider(DateUsageType.insurance))
            .isDateValid(); //button for date bottomsheet insurance
      case PagesTitleEnum.dateBottomSheetServices:
        return ref
            .watch(dateInputProvider(DateUsageType.services))
            .isDateValid(); //button for date bottomsheet for services
      case PagesTitleEnum.skipNickName:
        return true; // skip nickName set
      default:
        return false;
    }
  }

  String _getCurrentButtonTextWithCurrentPage() {
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
      default:
        return "تایید و ادامه";
    }
  }

  String _getCurrentButtonTextWithPagesTitleEnum() {
    switch (pagesTitleEnum) {
      case PagesTitleEnum.dateBottomSheetInsurance:
        return "تایید"; //button for date bottomsheet insurance
      case PagesTitleEnum.dateBottomSheetServices:
        return "تایید"; //button for date bottomsheet for services
      case PagesTitleEnum.skipNickName:
        return "ادامه بدون لقب"; // skip nickName set
      case PagesTitleEnum.repairInfo:
        return "ثبت";
      default:
        return "تایید و ادامه";
    }
  }
}
