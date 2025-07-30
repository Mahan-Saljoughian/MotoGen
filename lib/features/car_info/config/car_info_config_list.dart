import 'package:motogen/features/car_info/config/car_info_field_config.dart';
import 'package:motogen/features/car_info/config/date_set_field_config.dart';
import 'package:motogen/features/car_info/config/picker_field_config.dart';

final List<CarInfoFieldConfig> carInfoFirstPageFields = [
  CarInfoFieldConfig(
    type: FieldInputType.picker,
    pickerConfig: brandPickConfig,
    errorGetter: (s) => s.brandError,
  ),

  CarInfoFieldConfig(
    type: FieldInputType.picker,
    pickerConfig: modelPickConfig,
    errorGetter: (s) => s.modelError,
  ),

  CarInfoFieldConfig(
    type: FieldInputType.picker,
    pickerConfig: typePickConfig,
    errorGetter: (s) => s.typeError,
  ),

  CarInfoFieldConfig(
    type: FieldInputType.picker,
    pickerConfig: yearMadePickConfig,
    errorGetter: (s) => s.yearMadeError,
  ),

  CarInfoFieldConfig(
    type: FieldInputType.picker,
    pickerConfig: colorPickConfig,
    errorGetter: (s) => s.colorError,
  ),
];

final List<CarInfoFieldConfig> carInfoSecondPageFields = [
  CarInfoFieldConfig(labelText: "کیلومتر", type: FieldInputType.text),

  CarInfoFieldConfig(
    type: FieldInputType.picker,
    pickerConfig: fuelTypePickConfig,
    errorGetter: (s) => s.fuelTypeError,
  ),

  CarInfoFieldConfig(
    type: FieldInputType.dateSetter,
    dateSetFieldConfig: insuranceExpiryDateConfig,
    errorGetter: (s) => s.insuranceExpiryError,
  ),

  CarInfoFieldConfig(
    type: FieldInputType.dateSetter,
    dateSetFieldConfig: nextTechnicalCheckDateonfig,
    errorGetter: (s) => s.nextTechnicalCheckError,
  ),
];
