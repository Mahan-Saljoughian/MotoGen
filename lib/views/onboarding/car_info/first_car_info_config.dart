import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/models/car_form_state.dart';
import 'package:motogen/viewmodels/car_info/car_info_form_viewmodel.dart';
import 'package:motogen/views/onboarding/car_info/picker_and_field_config.dart';

final List<CarInfoFieldConfig> carInfoFirstPageFields = [

  CarInfoFieldConfig(
    labelText: "برند خودرو",
    type: FieldInputType.picker,
    pickerConfig: brandPickConfig,
  ),

  CarInfoFieldConfig(
    labelText: "مدل خودرو",
    type: FieldInputType.picker,
    pickerConfig: modelPickConfig,
  ),

  CarInfoFieldConfig(
    labelText: "تیپ خودرو",
    type: FieldInputType.picker,
    pickerConfig: typePickConfig,
  ),

  CarInfoFieldConfig(
    labelText: "سال ساخت خودرو",
    type: FieldInputType.picker,
    pickerConfig: yearMadePickConfig,
  ),

  CarInfoFieldConfig(
    labelText: "رنگ خودرو",
    type: FieldInputType.picker,
    pickerConfig: colorPickConfig,
  ),
];
