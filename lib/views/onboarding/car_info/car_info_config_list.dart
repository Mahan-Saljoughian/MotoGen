
import 'package:motogen/views/onboarding/car_info/car_info_field_config.dart';
import 'package:motogen/views/onboarding/car_info/picker_field_config.dart';

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

final List<CarInfoFieldConfig> carInfoSecondPageFields = [
  CarInfoFieldConfig(labelText: "کیلومتر", type: FieldInputType.text),

  CarInfoFieldConfig(
    labelText: "نوع سوخت",
    type: FieldInputType.picker,
    pickerConfig: fuelTypePickConfig,
  ),

  //both dates
];
