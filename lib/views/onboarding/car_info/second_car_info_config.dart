import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/models/car_form_state.dart';
import 'package:motogen/viewmodels/car_info/car_info_form_viewmodel.dart';
import 'package:motogen/viewmodels/personal_info_view_model.dart';
import 'package:motogen/views/onboarding/car_info/picker_and_field_config.dart';

final List<CarInfoFieldConfig> carInfoSecondPageFields = [
  CarInfoFieldConfig(
    labelText: "کیلومتر",
    type: FieldInputType.text,
  ),

  CarInfoFieldConfig(
    labelText: "نوع سوخت",
    type: FieldInputType.picker,
    pickerConfig: fuelTypePickConfig,
  ),

  //both dates
];
