import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/features/car_info/viewmodels/car_info_form_viewmodel.dart';
import 'package:motogen/widgets/field_text.dart';

class KilometerTextField extends ConsumerStatefulWidget {
  final String label;
  const KilometerTextField({required this.label, super.key});

  @override
  ConsumerState<KilometerTextField> createState() => _KilometerTextFieldState();
}

class _KilometerTextFieldState extends ConsumerState<KilometerTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final kilometerText = ref.read(
      carInfoFormProvider.select((s) => s.rawKilometersInput),
    );
    _controller = TextEditingController(text: kilometerText ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kilometerText = ref.watch(
      carInfoFormProvider.select((s) => s.rawKilometersInput),
    );
    final kilometerError = ref.watch(
      carInfoFormProvider.select((s) => s.kilometerError),
    );
    final isKmValid = ref.watch(
      carInfoFormProvider.select((s) => s.isKilometerValid),
    );
    // Sync only when provider changes (avoid overwrite on local edits)
    if (_controller.text != (kilometerText ?? '')) {
      _controller.text = kilometerText ?? '';
    }

    return FieldText(
      controller: _controller,
      isValid: isKmValid,
      labelText: widget.label,
      hintText: kilometerText ?? "انتخاب کنید...",
      onChanged: (text) =>
          ref.read(carInfoFormProvider.notifier).setRawKilometerInput(text),
      error: kilometerError,
    );
  }
}
