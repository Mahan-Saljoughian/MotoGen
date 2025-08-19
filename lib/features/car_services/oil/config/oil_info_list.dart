import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/bottom_sheet/config/car_info_field_config.dart';
import 'package:motogen/features/bottom_sheet/config/date_field_config.dart';
import 'package:motogen/features/bottom_sheet/config/field_text_config.dart';
import 'package:motogen/features/bottom_sheet/config/picker_field_config.dart';
import 'package:motogen/features/bottom_sheet/config/picker_item.dart';
import 'package:motogen/features/car_services/oil/model/oil_state_item.dart';
import 'package:motogen/features/car_services/oil/viewmodel/oil_draft_setters.dart';
import 'package:motogen/features/car_services/oil/viewmodel/oil_validation.dart';

List<CarInfoFieldConfig<OilStateItem>> buildOilInfoFields(
  OilStateItem draft,
  WidgetRef ref,
  TextEditingController oilBrandAndModelController,
  TextEditingController kilometerController,
  TextEditingController costController,
  TextEditingController locationController,
  TextEditingController notesController,
  bool isEdit,
) {
  return <CarInfoFieldConfig<OilStateItem>>[
    CarInfoFieldConfig<OilStateItem>(
      type: FieldInputType.dateSetter,
      dateSetFieldConfig: oilDateConfig,
      errorGetter: (s) => s.dateError,
    ),
    if (!isEdit) ...{
      CarInfoFieldConfig<OilStateItem>(
        type: FieldInputType.picker,
        pickerConfig: oilTypeConfig,
        errorGetter: (s) => s.oilTypeError,
      ),
    },
    CarInfoFieldConfig<OilStateItem>(
      type: FieldInputType.text,
      textConfig: FieldTextConfig(
        controller: oilBrandAndModelController,
        isValid: draft.isoilBrandAndModelValid,
        hintText: "مدل فلان برند فلان",
        labelText: "برند و مدل",
        error: draft.oilBrandAndModel,
        onChanged: ref.setRawOilBrandAndModel,
      ),
    ),
    CarInfoFieldConfig<OilStateItem>(
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
    CarInfoFieldConfig<OilStateItem>(
      type: FieldInputType.text,
      textConfig: FieldTextConfig(
        controller: costController,
        isValid: draft.isCostValid,
        hintText: "50,000",
        labelText: "هزینه",
        error: draft.costError,
        isNumberOnly: true,
        isTomanCost: true,
        onChanged: ref.setRawCost,
      ),
    ),
    if (draft.oilType?.id == "ENGINE") ...{
      CarInfoFieldConfig<OilStateItem>(
        type: FieldInputType.picker,
        pickerConfig: filtersChangedConfig,
      ),
    },

    CarInfoFieldConfig<OilStateItem>(
      type: FieldInputType.text,
      textConfig: FieldTextConfig(
        controller: locationController,
        isValid: draft.isLocationValid,
        hintText: "تعویض روغنی فلانی",
        labelText: "موقعیت",
        error: draft.locationError,
        onChanged: ref.setRawLocation,
      ),
    ),
    CarInfoFieldConfig<OilStateItem>(
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

DateFieldConfig<OilStateItem> oilDateConfig = DateFieldConfig<OilStateItem>(
  labelText: "تاریخ",
  getter: (state) => state.date,
  setter: (WidgetRef ref, value) {
    final current = ref.read(oillDraftProvider);
    ref.read(oillDraftProvider.notifier).state = current.copyWith(
      date: value,
      isDateInteractedOnce: true,
    );
    if (ref.read(oillDraftProvider.notifier).state.oilType?.id == "ENGINE") {}
  },
  usageType: DateUsageType.services,
);

PickerFieldConfig<OilStateItem> oilTypeConfig = PickerFieldConfig<OilStateItem>(
  labelText: "نوع",
  providerBuilder: (state) => oilTypeAsyncProvider,
  getter: (OilStateItem state) => state.oilType,
  setter: (WidgetRef ref, PickerItem? value) {
    final current = ref.read(oillDraftProvider);
    ref.read(oillDraftProvider.notifier).state = current.copyWith(
      oilType: value,
      isOilTypeInteractedOnce: true,
    );
  },
);

PickerFieldConfig<OilStateItem> filtersChangedConfig =
    PickerFieldConfig<OilStateItem>(
      labelText: "تعویض فیلتر",
      providerBuilder: (state) =>
          filtersChangedAsyncProvider, // returns 4 PickerItems
      multiGetter: (OilStateItem state) {
        final list = <PickerItem>[];
        if (state.oilFilterChanged == true) {
          list.add(PickerItem(id: 'oilFilterChanged', title: "فیلتر روغن"));
        }
        if (state.airFilterChanged == true) {
          list.add(PickerItem(id: 'airFilterChanged', title: "فیلتر هوا"));
        }
        if (state.cabinFilterChanged == true) {
          list.add(PickerItem(id: 'cabinFilterChanged', title: "فیلتر کابین"));
        }
        if (state.fuelFilterChanged == true) {
          list.add(PickerItem(id: 'fuelFilterChanged', title: "فیلتر سوخت"));
        }
        return list;
      },
      multiSetter: (ref, items) {
        final current = ref.read(oillDraftProvider);
        ref.read(oillDraftProvider.notifier).state = current.copyWith(
          oilFilterChanged: items.any((e) => e.id == 'oilFilterChanged'),
          airFilterChanged: items.any((e) => e.id == 'airFilterChanged'),
          cabinFilterChanged: items.any((e) => e.id == 'cabinFilterChanged'),
          fuelFilterChanged: items.any((e) => e.id == 'fuelFilterChanged'),
        );
      },
      isMultiSelect: true,
    );

final oilTypeProvider = Provider<List<PickerItem>>(
  (ref) => [
    PickerItem(id: 'ENGINE', title: 'موتور'),
    PickerItem(id: 'GEARBOX', title: 'گیربکس'),
    PickerItem(id: 'BRAKE', title: 'ترمز'),
    PickerItem(id: 'STEERING', title: 'فرمان'),
  ],
);

final oilTypeAsyncProvider = Provider<AsyncValue<List<PickerItem>>>((ref) {
  final list = ref.watch(oilTypeProvider);
  return AsyncValue.data(list);
});

final filtersChangedProvider = Provider<List<PickerItem>>(
  (ref) => [
    PickerItem(id: 'oilFilterChanged', title: 'فیلتر روغن'),
    PickerItem(id: 'airFilterChanged', title: 'فیلتر هوا'),
    PickerItem(id: 'cabinFilterChanged', title: 'فیلتر کابین'),
    PickerItem(id: 'fuelFilterChanged', title: 'فیلتر کابین'),
  ],
);

final filtersChangedAsyncProvider = Provider<AsyncValue<List<PickerItem>>>((
  ref,
) {
  final list = ref.watch(filtersChangedProvider);
  return AsyncValue.data(list);
});
