import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:motogen/core/storage/hive_storage.dart';
import 'package:motogen/core/storage/shared_prefs_storage.dart';
import 'package:motogen/features/car_info/data/complete_profile_api.dart';
import 'package:motogen/features/car_info/models/car_form_state.dart';
import 'package:motogen/features/car_info/config/picker_item.dart';

final carInfoFormProvider =
    NotifierProvider<CarInfoFormViewmodel, CarFormState>(
      () => CarInfoFormViewmodel(),
    );

class CarInfoFormViewmodel extends Notifier<CarFormState> {
  final kilometeDrivenController = TextEditingController();

  @override
  CarFormState build() {
    return const CarFormState();
  }

  // ---- Setters for form fields
  void setBrand(PickerItem? brand) {
    state = state.copyWith(
      brand: brand,
      isBrandInteractedOnce: state.isBrandInteractedOnce || true,
      model: PickerItem.noValueString,
      type: PickerItem.noValueString,
      yearMade: PickerItem.yearNoValue,
    );
  }

  void setModel(PickerItem? model) {
    state = state.copyWith(
      model: model,
      isModelInteractedOnce: state.isModelInteractedOnce || true,
      type: PickerItem.noValueString,
      yearMade: PickerItem.yearNoValue,
    );
  }

  void setType(PickerItem? type) => state = state.copyWith(
    type: type,
    isTypeInteractedOnce: state.isTypeInteractedOnce || true,
    yearMade: PickerItem.yearNoValue,
  );

  void setYearMade(int? year) => state = state.copyWith(
    yearMade: year,
    isYearMadeInteractedOnce: state.isYearMadeInteractedOnce || true,
  );

  void setColor(PickerItem? color) => state = state.copyWith(
    color: color,
    isColorInteractedOnce: state.isColorInteractedOnce || true,
  );
  void setKilometerDriven(int? km) =>
      state = state.copyWith(kilometerDriven: km);

  void setFuelType(PickerItem? fuel) => state = state.copyWith(
    fuelType: fuel,
    isFuelTypeInteractedOnce: state.isFuelTypeInteractedOnce || true,
  );

  void setBodyInsuranceExpiry(DateTime? date) => state = state.copyWith(
    bodyInsuranceExpiry: date,
    isBodyInsuranceExpiryInteractedOnce:
        state.isBodyInsuranceExpiryInteractedOnce || true,
  );

  void setNextTechnicalCheck(DateTime? date) => state = state.copyWith(
    nextTechnicalCheck: date,
    isNextTechnicalCheckInteractedOnce:
        state.isNextTechnicalCheckInteractedOnce || true,
  );

  void setThirdPersonInsuranceExpiry(DateTime? date) => state = state.copyWith(
    thirdPartyInsuranceExpiry: date,
    isThirdPartyInsuranceExpiryInteractedOnce:
        state.isThirdPartyInsuranceExpiryInteractedOnce || true,
  );
  void setNickName(String? nickNameText) =>
      state = state.copyWith(nickName: nickNameText);

  // ----kilometer validation------

  void setRawKilometerInput(String input) {
    state = state.copyWith(rawKilometersInput: input);
    final parsed = int.tryParse(input);
    if (parsed != null && parsed >= 0 && parsed <= 1000000) {
      state = state.copyWith(kilometerDriven: parsed);
    } else {
      state = state.copyWith(kilometerDriven: null);
    }
  }


  // local save after success on complete profile or error if unsuccess
  Future<Map<String, dynamic>> completeProfile({
    required bool isSetNickName,
    required String nickNametext,
    required Map<String, String> userInfo,
    required String phoneNumber,
  }) async {
    try {
      if (isSetNickName) {
        setNickName(nickNametext.trim());
      }
      final api = CompleteProfileApi();
      final response = await api.completeProfile(state, userInfo);
      await SharedPrefsStorage.saveUserInfo(
        firstName: userInfo['firstName'],
        lastName: userInfo['lastName'],
        phoneNumber: phoneNumber,
        isProfileCompleted: true,
      );
      await HiveStorage.saveCarInfo(state);
      return response;
    } catch (e) {
      Logger().e('Complete profile error : $e');
      rethrow;
    }
  }
}
