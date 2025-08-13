import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/bottom_sheet/config/picker_item.dart';

class PickerFieldConfig<T> {
  final String labelText;
  final ProviderListenable<AsyncValue<List<PickerItem>>> Function(T state)
  providerBuilder;

  final PickerItem? Function(T state) getter;
  final void Function(WidgetRef ref, PickerItem? val) setter;
  PickerFieldConfig({
    required this.labelText,
    required this.providerBuilder,
    required this.getter,
    required this.setter,
  });
}
