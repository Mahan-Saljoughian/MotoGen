import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/bottom_sheet/config/car_info_field_config.dart';
import 'package:motogen/features/car_info/config/car_date_field_config.dart';
import 'package:motogen/features/bottom_sheet/config/field_text_config.dart';
import 'package:motogen/features/car_info/config/car_picker_field_config.dart';
import 'package:motogen/features/car_info/models/car_form_state_item.dart';
import 'package:motogen/features/car_info/viewmodels/car_draft_setters.dart';
import 'package:motogen/features/car_info/viewmodels/car_validation.dart';

List<CarInfoFieldConfig<CarFormStateItem>> buildCarInfoFirstPageFields(
  bool isformEdit,
) {
  return [
    if (!isformEdit) ...[
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
    ],
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
}

List<CarInfoFieldConfig<CarFormStateItem>> buildCarInfoSecondPageFields(
  CarFormStateItem draft,
  TextEditingController kmController,
  WidgetRef ref,
) {
  return [
    CarInfoFieldConfig<CarFormStateItem>(
      type: FieldInputType.text,
      textConfig: FieldTextConfig(
        controller: kmController,
        isValid: draft.isKilometerValid,
        hintText: "41,000",
        labelText: "کیلومتر",
        error: draft.kilometerError,
        isNumberOnly: true,
        onChanged: ref.setRawKilometer,
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
      dateSetFieldConfig: nextTechnicalCheckDateConfig,
      errorGetter: (s) => s.nextTechnicalCheckError,
    ),
  ];
}

// ------------- For Add/Edit (One‑page) -----------------
List<CarInfoFieldConfig<CarFormStateItem>> buildFullCarInfoFields(
  CarFormStateItem draft,
  TextEditingController kmController,
  TextEditingController nickNameController,
  WidgetRef ref,
  bool isformEdit,
) {
  return [
    ...buildCarInfoFirstPageFields(isformEdit),
    ...buildCarInfoSecondPageFields(draft, kmController, ref),

    CarInfoFieldConfig<CarFormStateItem>(
      type: FieldInputType.text,
      textConfig: FieldTextConfig(
        controller: nickNameController,
        isValid: draft.isNickNameValid,
        hintText: "وارد کنید...",
        labelText: "لقب (اختیاری)",
        error: draft.nickNameError,
        onChanged: ref.setNickName,
      ),
    ),
  ];
}
