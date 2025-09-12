import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/bottom_sheet/config/picker_item.dart';
import 'package:motogen/features/car_info/models/car_form_state_item.dart';
import 'package:motogen/features/car_info/viewmodels/car_draft_setters.dart';

extension CarValidation on CarFormStateItem {
  String? get brandError =>
      isBrandInteractedOnce && brand == null ? 'الزامی!' : null;

  String? get modelError =>
      isModelInteractedOnce &&
          (model == null || model == PickerItem.noValueString)
      ? 'الزامی!'
      : null;

  String? get typeError =>
      isTypeInteractedOnce && (type == null || type == PickerItem.noValueString)
      ? 'الزامی!'
      : null;

  String? get yearMadeError =>
      isYearMadeInteractedOnce &&
          (yearMade == null || yearMade == PickerItem.yearNoValue)
      ? 'الزامی!'
      : null;

  String? get fuelTypeError =>
      isFuelTypeInteractedOnce && fuelType == null ? 'الزامی!' : null;

  String? get thirdPartyInsuranceExpiryError =>
      isThirdPartyInsuranceExpiryInteractedOnce &&
          thirdPartyInsuranceExpiry == null
      ? 'الزامی!'
      : null;

  String? get nextTechnicalCheckError =>
      isNextTechnicalCheckInteractedOnce && nextTechnicalCheck == null
      ? 'الزامی!'
      : null;

  String? get colorError =>
      isColorInteractedOnce && color == null ? 'الزامی!' : null;

  //nickname validation
  static final RegExp _nicknameRegExp = RegExp(
    r'^[\u0600-\u06FFa-zA-Z0-9\u06F0-\u06F9 ]+$',
  );
  static const int _minNickLength = 1;
  static const int _maxNickLength = 15;

  String? get nickNameError {
    if (nickName == null || nickName!.trim().isEmpty) {
      return null;
    }
    final trimmed = nickName!.trim();
    if (trimmed.length < _minNickLength || trimmed.length > _maxNickLength) {
      return "نام مستعار باید بین 1 تا 15 کاراکتر باشد";
    }
    if (!_nicknameRegExp.hasMatch(trimmed)) {
      return "فقط حروف، اعداد و فاصله مجاز است";
    }
    return null;
  }

  bool get isNickNameValid => nickNameError == null;
}

final isCarInfoButtonEnabledForFirstPageProvider = Provider<bool>((ref) {
  final draft = ref.watch(carDraftProvider);
  final hasBrand =
      draft.brand != null && draft.brand != PickerItem.noValueString;
  final hasModel =
      draft.model != null && draft.model != PickerItem.noValueString;
  final hasType = draft.type != null && draft.type != PickerItem.noValueString;
  final hasYear =
      draft.yearMade != null && draft.yearMade != PickerItem.yearNoValue;
  final hasColor = draft.color != null;

  return hasBrand && hasModel && hasType && hasYear && hasColor;
});

final isCarInfoButtonEnabledForSecondPageProvider = Provider<bool>((ref) {
  final draft = ref.watch(carDraftProvider);
  return draft.isKilometerValid &&
      draft.fuelType != null &&
      draft.thirdPartyInsuranceExpiry != null &&
      draft.nextTechnicalCheck != null;
});

final isNickNameButtonEnabled = Provider<bool>((ref) {
  final draft = ref.watch(carDraftProvider);
  final text = draft.nickName?.trim() ?? '';
  return text.isNotEmpty && draft.isNickNameValid;
});
