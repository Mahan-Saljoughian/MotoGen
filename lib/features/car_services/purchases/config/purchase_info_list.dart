import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/bottom_sheet/config/car_info_field_config.dart';
import 'package:motogen/features/bottom_sheet/config/date_field_config.dart';
import 'package:motogen/features/bottom_sheet/config/field_text_config.dart';
import 'package:motogen/features/bottom_sheet/config/picker_field_config.dart';
import 'package:motogen/features/bottom_sheet/config/picker_item.dart';
import 'package:motogen/features/car_services/purchases/model/purhcase_state_item.dart';
import 'package:motogen/features/car_services/purchases/viewmodel/purchase_draft_setters.dart';

List<CarInfoFieldConfig<PurhcaseStateItem>> buildPurchasesInfoFields(
  PurhcaseStateItem draft,
  WidgetRef ref,
  TextEditingController partController,
  TextEditingController locationController,
  TextEditingController costController,
  TextEditingController notesController,
) {
  return [
    CarInfoFieldConfig<PurhcaseStateItem>(
      type: FieldInputType.dateSetter,
      dateSetFieldConfig: purchaseDateConfig,
      errorGetter: (s) => s.dateError,
    ),
    CarInfoFieldConfig<PurhcaseStateItem>(
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
    CarInfoFieldConfig<PurhcaseStateItem>(
      type: FieldInputType.picker,
      pickerConfig: purchaseCategoryConfig,
      errorGetter: (s) => s.purchaseCategoryError,
    ),

    CarInfoFieldConfig<PurhcaseStateItem>(
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
    CarInfoFieldConfig<PurhcaseStateItem>(
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

    CarInfoFieldConfig<PurhcaseStateItem>(
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

DateFieldConfig<PurhcaseStateItem> purchaseDateConfig =
    DateFieldConfig<PurhcaseStateItem>(
      labelText: "تاریخ",
      getter: (state) => state.date,
      setter: (WidgetRef ref, value) {
        final current = ref.read(purchaseDraftProvider);
        ref.read(purchaseDraftProvider.notifier).state = current.copyWith(
          date: value,
          isDateInteractedOnce: true,
        );
      },
      usageType: DateUsageType.services,
    );

PickerFieldConfig<PurhcaseStateItem> purchaseCategoryConfig =
    PickerFieldConfig<PurhcaseStateItem>(
      labelText: "دسته‌بندی",
      providerBuilder: (state) => purchaseCategoryAsyncProvider,
      getter: (PurhcaseStateItem state) => state.purchaseCategory,
      setter: (WidgetRef ref, PickerItem? value) {
        final current = ref.read(purchaseDraftProvider);
        ref.read(purchaseDraftProvider.notifier).state = current.copyWith(
          purchaseCategory: value,
          isPurchaseCategoryInteractedOnce: true,
        );
      },
    );

final purchaseCategoryProvider = Provider<List<PickerItem>>(
  (ref) => [
    PickerItem(id: 'MECHANICAL', title: 'مکانیکی'),
    PickerItem(id: 'CONSUMABLE', title: 'مصرفی'),
    PickerItem(id: 'BODY_AND_TRIM', title: 'بدنه و تزئینات'),
  ],
);

final purchaseCategoryAsyncProvider = Provider<AsyncValue<List<PickerItem>>>((
  ref,
) {
  final list = ref.watch(purchaseCategoryProvider);
  return AsyncValue.data(list);
});
