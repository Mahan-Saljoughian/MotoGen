import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/models/car_form_state.dart';
import 'package:motogen/viewmodels/car_info/car_info_form_viewmodel.dart';

class PickerFieldConfig {
  final String labelText;
  final List<String> items;
  final String? Function(CarFormState state) getter;
  final void Function(WidgetRef ref, String? val) setter;
  PickerFieldConfig({
    required this.labelText,
    required this.items,
    required this.getter,
    required this.setter,
  });
}

PickerFieldConfig brandPickConfig = PickerFieldConfig(
  labelText: "برند خودرو",
  items: ["یک", "دو"],
  getter: (CarFormState state) => state.brand,
  setter: (WidgetRef ref, value) =>
      ref.read(CarInfoFormProvider.notifier).setBrand(value),
);

PickerFieldConfig modelPickConfig = PickerFieldConfig(
  labelText: "مدل خودرو",
  items: ["یک", "دو"],
  getter: (CarFormState state) => state.model,
  setter: (WidgetRef ref, value) =>
      ref.read(CarInfoFormProvider.notifier).setModel(value),
);

PickerFieldConfig typePickConfig = PickerFieldConfig(
  labelText: "تیپ خودرو",
  items: ["یک", "دو"],
  getter: (CarFormState state) => state.type,
  setter: (WidgetRef ref, value) =>
      ref.read(CarInfoFormProvider.notifier).setType(value),
);

PickerFieldConfig yearMadePickConfig = PickerFieldConfig(
  labelText: "سال ساخت خودرو",
  items: ["1", "2"],
  getter: (CarFormState state) => state.yearMade?.toString(),
  setter: (WidgetRef ref, value) {
    int? yearInt = int.tryParse(value ?? '');
    ref.read(CarInfoFormProvider.notifier).setYearMade(yearInt);
  },
);

PickerFieldConfig colorPickConfig = PickerFieldConfig(
  labelText: "رنگ خودرو",
  items: ["یک", "دو"],
  getter: (CarFormState state) => state.color,
  setter: (WidgetRef ref, value) =>
      ref.read(CarInfoFormProvider.notifier).setColor(value),
);

PickerFieldConfig fuelTypePickConfig = PickerFieldConfig(
  labelText: "نوع سوخت",
  items: ["یک", "دو"],
  getter: (CarFormState state) => state.fuelType,
  setter: (WidgetRef ref, value) =>
      ref.read(CarInfoFormProvider.notifier).setFuelType(value),
);

/* PickerFieldConfig insuranceExpiryFieldConfig = PickerFieldConfig(
  labelText: "تاریخ انقضای بیمه",
  items: ["یک", "دو"],
  getter: (CarFormState state) => state.insuranceExpiry,
  setter: (WidgetRef ref, value) =>
      ref.read(CarInfoFormProvider.notifier).setInsuranceExpiry(value),
);

PickerFieldConfig nextTechnicalCheckPickConfig = PickerFieldConfig(
  labelText: "تاریخ معاینه فنی بعدی",
  items: ["یک", "دو"],
  getter: (CarFormState state) => state.nextTechnicalCheck,
  setter: (WidgetRef ref, value) =>
      ref.read(CarInfoFormProvider.notifier).setNextTechnicalCheck(value),
);
 */

enum FieldInputType { picker, text }

class CarInfoFieldConfig {
  final String labelText;
  final FieldInputType type;
  final PickerFieldConfig? pickerConfig;

  CarInfoFieldConfig({
    required this.labelText,
    required this.type,
    this.pickerConfig,
  });
}
