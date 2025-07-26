import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/car_info/models/car_form_state.dart';
import 'package:motogen/features/car_info/viewmodels/car_info_form_viewmodel.dart';

import 'package:shamsi_date/shamsi_date.dart';

class DateSetFieldConfig {
  final String labelText;
  final DateTime? Function(CarFormState state) getter;
  final void Function(WidgetRef ref, DateTime? dateValue) setter;

  DateSetFieldConfig({
    required this.labelText,
    required this.getter,
    required this.setter,
  });
}

DateSetFieldConfig insuranceExpiryDateConfig = DateSetFieldConfig(
  labelText: "تاریخ انقضای بیمه",
  getter: (CarFormState state) => state.insuranceExpiry,
  setter: (WidgetRef ref, value) =>
      ref.read(carInfoFormProvider.notifier).setInsuranceExpiry(value),
);

DateSetFieldConfig nextTechnicalCheckDateonfig = DateSetFieldConfig(
  labelText: "تاریخ معاینه فنی بعدی",
  getter: (CarFormState state) => state.nextTechnicalCheck,
  setter: (WidgetRef ref, value) =>
      ref.read(carInfoFormProvider.notifier).setNextTechnicalCheck(value),
);

String formatJalaliDate(DateTime date) {
  final j = Jalali.fromDateTime(date);
  return '${j.year}/${j.month.toString().padLeft(2, '0')}/${j.day.toString().padLeft(2, '0')}';
}
