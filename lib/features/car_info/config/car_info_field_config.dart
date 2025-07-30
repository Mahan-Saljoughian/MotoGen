import 'package:motogen/features/car_info/config/date_set_field_config.dart';
import 'package:motogen/features/car_info/config/picker_field_config.dart';
import 'package:motogen/features/car_info/models/car_form_state.dart';

enum FieldInputType { picker, text, dateSetter }

class CarInfoFieldConfig {
  final String? labelText;
  final FieldInputType type;
  final PickerFieldConfig? pickerConfig;
  final DateSetFieldConfig? dateSetFieldConfig;
  final String? Function(CarFormState)? errorGetter;

  CarInfoFieldConfig({
    this.labelText,
    required this.type,
    this.pickerConfig,
    this.dateSetFieldConfig,
    this.errorGetter,
  });
}
