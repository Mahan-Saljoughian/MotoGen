import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/services/format_functions.dart';
import 'package:motogen/features/bottom_sheet/widgets/bottomsheet_date_show.dart';
import 'package:motogen/features/bottom_sheet/widgets/bottomsheet_list_show.dart';
import 'package:motogen/features/bottom_sheet/widgets/bottomsheet_picker_field.dart';
import 'package:motogen/features/bottom_sheet/config/car_info_field_config.dart';
import 'package:motogen/widgets/field_text.dart';

class BuildFormFields<T> extends ConsumerWidget {
  final ProviderListenable<T> provider;
  final List<CarInfoFieldConfig<T>> Function(T state, WidgetRef ref)
  fieldsBuilder;

  const BuildFormFields({
    super.key,
    required this.provider,
    required this.fieldsBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    final fields = fieldsBuilder(state, ref);

    return Column(
      children: List.generate(fields.length, (idx) {
        final fieldConfig = fields[idx];
        switch (fieldConfig.type) {
          case FieldInputType.picker:
            final fieldPickerConfig = fieldConfig.pickerConfig!;
            String? selectedText;
            if (fieldPickerConfig.isMultiSelect) {
              // Safe: join titles of selected items
              final items = fieldPickerConfig.multiGetter!(state);
              if (items.isNotEmpty) {
                selectedText = items.map((e) => e.title).join(', ');
              }
            } else {
              selectedText = fieldPickerConfig.getter!(state)?.title;
            }

            return BottomsheetPickerField(
              labelText: fieldConfig.pickerConfig!.labelText,
              selectedText: selectedText,
              onPressed: () {
                BottomsheetListShow.showSelectionBottomSheet<T>(
                  context: ref.context,
                  config: fieldConfig.pickerConfig!,
                  ref: ref,
                  state: state,
                );
              },
              errorText: fieldConfig.errorGetter?.call(state),
            );

          case FieldInputType.text:
            return FieldText(
              controller: fieldConfig.textConfig!.controller,
              labelText: fieldConfig.textConfig!.labelText,
              hintText: fieldConfig.textConfig!.hintText!,
              isValid: fieldConfig.textConfig!.isValid,
              error: fieldConfig.textConfig!.error,
              isNumberOnly: fieldConfig.textConfig!.isNumberOnly,

              isTomanCost: fieldConfig.textConfig!.isTomanCost,
              isNotes: fieldConfig.textConfig!.isNotes,
              onChanged: fieldConfig.textConfig!.onChanged,
            );

          case FieldInputType.dateSetter:
            final date = fieldConfig.dateSetFieldConfig!.getter(state);
            return BottomsheetPickerField(
              labelText: fieldConfig.dateSetFieldConfig!.labelText,
              selectedText: date != null ? formatJalaliDate(date) : null,
              onPressed: () async {
                final pickedDate = await showModalBottomSheet<DateTime?>(
                  context: ref.context,
                  isScrollControlled: true,
                  isDismissible: true,
                  enableDrag: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(40.r),
                    ),
                  ),
                  builder: (_) => BottomsheetDateShow<T>(
                    dateSetFieldConfig: fieldConfig.dateSetFieldConfig!,
                    state: state,
                    usageType: fieldConfig.dateSetFieldConfig!.usageType,
                  ),
                );
                fieldConfig.dateSetFieldConfig!.setter(ref, pickedDate);
              },
              errorText: fieldConfig.errorGetter?.call(state),
            );
        }
      }),
    );
  }
}
