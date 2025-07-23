import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/models/car_form_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

final CarInfoFormProvider =
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
  void setBrand(String? brand) => state = state.copyWith(brand: brand);
  void setModel(String? model) => state = state.copyWith(model: model);
  void setType(String? type) => state = state.copyWith(type: type);
  void setYearMade(int? year) => state = state.copyWith(yearMade: year);
  void setColor(String? color) => state = state.copyWith(color: color);
  void setKilometerDriven(int? km) =>
      state = state.copyWith(kilometerDriven: km);
  void setInsuranceExpiry(DateTime? date) =>
      state = state.copyWith(insuranceExpiry: date);
  void setNextTechnicalCheck(DateTime? date) =>
      state = state.copyWith(nextTechnicalCheck: date);
  void setFuelType(String? fuel) => state = state.copyWith(fuelType: fuel);

  // ----kilometer validation------

  void setRawKilometerInput(String input) {
  state = state.copyWith(rawKilometersInput: input);
  final parsed = int.tryParse(input);
  if (parsed != null && parsed >= 0 && parsed < 1000000) {
    state = state.copyWith(kilometerDriven: parsed);
  } else {
    state = state.copyWith(kilometerDriven: null); // Invalid or empty
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

  @override
  void dispose() {
    kilometeDrivenController.dispose();
  }
}
