import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateFieldConfig<T> {
  final String labelText;
  final DateTime? Function(T state) getter;
  final void Function(WidgetRef ref, DateTime? dateValue) setter;

  DateFieldConfig({
    required this.labelText,
    required this.getter,
    required this.setter,
  });
}
