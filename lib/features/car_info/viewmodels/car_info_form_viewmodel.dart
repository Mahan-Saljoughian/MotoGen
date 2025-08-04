import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:motogen/features/car_info/models/car_form_state.dart';
import 'package:motogen/features/car_info/config/picker_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    Logger().i(
      "[DEBUG] brand: ${state.brand}, model: ${state.model}, type: ${state.type}, yearMade: ${state.yearMade}, color: ${state.color} , isBrandInteractedOnce: ${state.isBrandInteractedOnce}, isModelInteractedOnce: ${state.isModelInteractedOnce}",
    );
  }

  void setModel(PickerItem? model) {
    state = state.copyWith(
      model: model,
      isModelInteractedOnce: state.isModelInteractedOnce || true,
      type: PickerItem.noValueString,
      yearMade: PickerItem.yearNoValue,
    );
    Logger().i(
      "[DEBUG] brand: ${state.brand}, model: ${state.model}, type: ${state.type}, yearMade: ${state.yearMade}, color: ${state.color} ,isBrandInteractedOnce: ${state.isBrandInteractedOnce}, isModelInteractedOnce: ${state.isModelInteractedOnce}",
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

  void setInsuranceExpiry(DateTime? date) => state = state.copyWith(
    insuranceExpiry: date,
    isInsuranceExpiryInteractedOnce:
        state.isInsuranceExpiryInteractedOnce || true,
  );

  void setNextTechnicalCheck(DateTime? date) => state = state.copyWith(
    nextTechnicalCheck: date,
    isNextTechnicalCheckInteractedOnce:
        state.isNextTechnicalCheckInteractedOnce || true,
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

  //------sharedPref------
  Future<void> saveToPref() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('car_form', jsonEncode(state.toJson()));
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('car_form');
    if (data != null) {
      state = CarFormState.fromJson(jsonDecode(data));
    }
  }

  Future<void> clearForm() async {
    state = const CarFormState();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('car_form');
  }
}
