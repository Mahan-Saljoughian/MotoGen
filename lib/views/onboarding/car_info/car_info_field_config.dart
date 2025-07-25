
import 'package:motogen/views/onboarding/car_info/picker_field_config.dart';

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
