
import 'package:motogen/features/car_info/config/car_info_field_config.dart';
import 'package:motogen/features/car_info/config/date_set_field_config.dart';
import 'package:motogen/features/car_info/config/picker_field_config.dart';

final List<CarInfoFieldConfig> carInfoFirstPageFields = [
  CarInfoFieldConfig(
    type: FieldInputType.picker,
    pickerConfig: brandPickConfig,
  ),

  CarInfoFieldConfig(
    type: FieldInputType.picker,
    pickerConfig: modelPickConfig,
  ),

  CarInfoFieldConfig(type: FieldInputType.picker, pickerConfig: typePickConfig),

  CarInfoFieldConfig(
    type: FieldInputType.picker,
    pickerConfig: yearMadePickConfig,
  ),

  CarInfoFieldConfig(
    type: FieldInputType.picker,
    pickerConfig: colorPickConfig,
  ),
];

final List<CarInfoFieldConfig> carInfoSecondPageFields = [
  CarInfoFieldConfig(labelText: "کیلومتر", type: FieldInputType.text),

  CarInfoFieldConfig(
    type: FieldInputType.picker,
    pickerConfig: fuelTypePickConfig,
  ),

  CarInfoFieldConfig(
    type: FieldInputType.dateSetter,
    dateSetFieldConfig: insuranceExpiryDateConfig,
  ),

  CarInfoFieldConfig(
    type: FieldInputType.dateSetter,
    dateSetFieldConfig: nextTechnicalCheckDateonfig,
  ),
];
