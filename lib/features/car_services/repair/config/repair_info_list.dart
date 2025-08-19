import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/bottom_sheet/config/car_info_field_config.dart';
import 'package:motogen/features/bottom_sheet/config/date_field_config.dart';
import 'package:motogen/features/bottom_sheet/config/field_text_config.dart';
import 'package:motogen/features/bottom_sheet/config/picker_field_config.dart';
import 'package:motogen/features/bottom_sheet/config/picker_item.dart';
import 'package:motogen/features/car_services/repair/model/repair_state_item.dart';
import 'package:motogen/features/car_services/repair/viewmodel/repair_draft_setters.dart';

List<CarInfoFieldConfig<RepairStateItem>> buildRepairInfoFields(
  RepairStateItem draft,
  WidgetRef ref,
  TextEditingController partController,
  TextEditingController kilometerController,
  TextEditingController locationController,
  TextEditingController costController,
  TextEditingController notesController,
) {
  return [
    CarInfoFieldConfig<RepairStateItem>(
      type: FieldInputType.dateSetter,
      dateSetFieldConfig: repairDateConfig,
      errorGetter: (s) => s.dateError,
    ),
    CarInfoFieldConfig<RepairStateItem>(
      type: FieldInputType.text,
      textConfig: FieldTextConfig(
        controller: partController,
        isValid: draft.isPartValid,
        hintText: "شمع",
        labelText: "قطعه",
        error: draft.partError,
        onChanged: ref.setRawPart,
      ),
    ),
    CarInfoFieldConfig<RepairStateItem>(
      type: FieldInputType.picker,
      pickerConfig: repairActionConfig,
      errorGetter: (s) => s.repairActionError,
    ),

    CarInfoFieldConfig<RepairStateItem>(
      type: FieldInputType.text,
      textConfig: FieldTextConfig(
        controller: kilometerController,
        isValid: draft.isKilometerValid,
        hintText: "41,000",
        labelText: "کیلومتر",
        error: draft.kilometerError,
        isNumberOnly: true,
        onChanged: ref.setRawKilometer,
      ),
    ),

    CarInfoFieldConfig<RepairStateItem>(
      type: FieldInputType.text,
      textConfig: FieldTextConfig(
        controller: costController,
        isValid: draft.isCostValid,
        hintText: "50,000",
        labelText: "هزینه",
        isNumberOnly: true,
        isTomanCost: true,
        error: draft.costError,
        onChanged: ref.setRawCost,
      ),
    ),
    CarInfoFieldConfig<RepairStateItem>(
      type: FieldInputType.text,
      textConfig: FieldTextConfig(
        controller: locationController,
        isValid: draft.isLocationValid,
        hintText: "مکانیکی فلانی",
        labelText: "موقعیت",
        error: draft.locationError,
        onChanged: ref.setRawLocation,
      ),
    ),

    CarInfoFieldConfig<RepairStateItem>(
      type: FieldInputType.text,
      textConfig: FieldTextConfig(
        controller: notesController,
        isValid: draft.isNoteValid,
        hintText: "توضیحاتت رو اینجا یادداشت کن...",
        labelText: "توضیحات",
        isNotes: true,
        error: draft.notesError,
        onChanged: ref.setRawNotes,
      ),
    ),
  ];
}

DateFieldConfig<RepairStateItem> repairDateConfig =
    DateFieldConfig<RepairStateItem>(
      labelText: "تاریخ",
      getter: (state) => state.date,
      setter: (WidgetRef ref, value) {
        final current = ref.read(repairDraftProvider);
        ref.read(repairDraftProvider.notifier).state = current.copyWith(
          date: value,
          isDateInteractedOnce: true,
        );
      },
      usageType: DateUsageType.services,
    );

PickerFieldConfig<RepairStateItem> repairActionConfig =
    PickerFieldConfig<RepairStateItem>(
      labelText: "اقدامات",
      providerBuilder: (state) => repairActionAsyncProvider,
      getter: (RepairStateItem state) => state.repairAction,
      setter: (WidgetRef ref, PickerItem? value) {
        final current = ref.read(repairDraftProvider);
        ref.read(repairDraftProvider.notifier).state = current.copyWith(
          repairAction: value,
          isRepairActionInteractedOnce: true,
        );
      },
    );

final repairActionProvider = Provider<List<PickerItem>>(
  (ref) => [
    PickerItem(id: 'REPAIR', title: 'تعمیر'),
    PickerItem(id: 'REPLACE ', title: 'َتعویض'),
  ],
);

final repairActionAsyncProvider = Provider<AsyncValue<List<PickerItem>>>((ref) {
  final list = ref.watch(repairActionProvider);
  return AsyncValue.data(list);
});
