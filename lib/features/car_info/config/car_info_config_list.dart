import 'package:motogen/features/bottom_sheet/config/car_info_field_config.dart';

import 'package:motogen/features/car_info/config/car_date_field_config.dart';
import 'package:motogen/features/bottom_sheet/config/field_text_config.dart';

import 'package:motogen/features/car_info/config/car_picker_field_config.dart';
import 'package:motogen/features/car_info/models/car_form_state_item.dart';
import 'package:motogen/features/car_info/viewmodels/car_state_notifier.dart';

final List<CarInfoFieldConfig<CarFormStateItem>> carInfoFirstPageFields = [
  CarInfoFieldConfig<CarFormStateItem>(
    type: FieldInputType.picker,
    pickerConfig: brandPickConfig,
    errorGetter: (s) => s.brandError,
  ),

  CarInfoFieldConfig<CarFormStateItem>(
    type: FieldInputType.picker,
    pickerConfig: modelPickConfig,
    errorGetter: (s) => s.modelError,
  ),

  CarInfoFieldConfig<CarFormStateItem>(
    type: FieldInputType.picker,
    pickerConfig: typePickConfig,
    errorGetter: (s) => s.typeError,
  ),

  CarInfoFieldConfig<CarFormStateItem>(
    type: FieldInputType.picker,
    pickerConfig: yearMadePickConfig,
    errorGetter: (s) => s.yearMadeError,
  ),

  CarInfoFieldConfig<CarFormStateItem>(
    type: FieldInputType.picker,
    pickerConfig: colorPickConfig,
    errorGetter: (s) => s.colorError,
  ),
];

List<CarInfoFieldConfig<CarFormStateItem>> buildCarInfoSecondPageFields(
  CarFormStateItem carState,
  CarStateNotifier carNotifier,
) {
  return [
    CarInfoFieldConfig<CarFormStateItem>(
      type: FieldInputType.text,
      textConfig: FieldTextConfig(
        controller: carNotifier.kilometeDrivenController,
        isValid: carState.isKilometerValid,
        hintText: "انتخاب کنید ...",
        labelText: "کیلومتر",
        error: carState.kilometerError,
        isNumberOnly: true,
        onChanged: carNotifier.setRawKilometerInput,
      ),
    ),
    CarInfoFieldConfig<CarFormStateItem>(
      type: FieldInputType.picker,
      pickerConfig: fuelTypePickConfig,
      errorGetter: (s) => s.fuelTypeError,
    ),
    CarInfoFieldConfig<CarFormStateItem>(
      type: FieldInputType.dateSetter,
      dateSetFieldConfig: bodyInsuranceExpiryDateConfig,
    ),
    CarInfoFieldConfig<CarFormStateItem>(
      type: FieldInputType.dateSetter,
      dateSetFieldConfig: thirdPersonInsuranceExpiryDateConfig,
      errorGetter: (s) => s.thirdPartyInsuranceExpiryError,
    ),
    CarInfoFieldConfig<CarFormStateItem>(
      type: FieldInputType.dateSetter,
      dateSetFieldConfig: nextTechnicalCheckDateonfig,
      errorGetter: (s) => s.nextTechnicalCheckError,
    ),
  ];
}
