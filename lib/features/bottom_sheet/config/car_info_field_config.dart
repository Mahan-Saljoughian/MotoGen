import 'package:motogen/features/bottom_sheet/config/date_field_config.dart';
import 'package:motogen/features/bottom_sheet/config/picker_field_config.dart';

import 'package:motogen/features/bottom_sheet/config/field_text_config.dart';


enum FieldInputType { picker, text, dateSetter }

class CarInfoFieldConfig<T> {
  final FieldInputType type;
  final PickerFieldConfig<T>? pickerConfig;
  final DateFieldConfig<T>? dateSetFieldConfig;
  final FieldTextConfig? textConfig;
  final String? Function(T)? errorGetter;

  CarInfoFieldConfig({
    required this.type,
    this.textConfig,
    this.pickerConfig,
    this.dateSetFieldConfig,
    this.errorGetter,
  });
}



