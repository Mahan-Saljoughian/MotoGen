import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/bottom_sheet/config/picker_item.dart';

class PickerFieldConfig<T> {
  final String labelText;
  final ProviderListenable<AsyncValue<List<PickerItem>>> Function(T state)
  providerBuilder;

  /// Single-select flow
  final PickerItem? Function(T state)? getter;
  final void Function(WidgetRef ref, PickerItem? val)? setter;

  /// Multi-select flow
  final List<PickerItem> Function(T state)? multiGetter;
  final void Function(WidgetRef ref, List<PickerItem> vals)? multiSetter;

  /// Switcher
  final bool isMultiSelect;
  PickerFieldConfig({
    required this.labelText,
    required this.providerBuilder,
    this.getter,
    this.setter,
    this.multiGetter,
    this.multiSetter,
    this.isMultiSelect = false,
  }) : assert(
         isMultiSelect
             ? multiGetter != null && multiSetter != null
             : getter != null && setter != null,
         'Must supply correct getter/setter for the mode you choose',
       );
}
