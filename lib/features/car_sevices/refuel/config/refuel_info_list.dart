import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/bottom_sheet/config/date_field_config.dart';
import 'package:motogen/features/bottom_sheet/config/picker_field_config.dart';
import 'package:motogen/features/bottom_sheet/config/picker_item.dart';
import 'package:motogen/features/bottom_sheet/config/car_info_field_config.dart';
import 'package:motogen/features/bottom_sheet/config/field_text_config.dart';
import 'package:motogen/features/car_sevices/refuel/model/refuel_state_item.dart';
import 'package:motogen/features/car_sevices/refuel/viewmodel/refuel_validation.dart';
import 'package:motogen/features/car_sevices/refuel/view/add_refuel_screen.dart';
import 'package:motogen/features/car_sevices/refuel/viewmodel/refuel_draft_setters.dart';

List<CarInfoFieldConfig<RefuelStateItem>> buildRefuelInfoFields(
  RefuelStateItem draft,
  WidgetRef ref,
) {
  return [
    CarInfoFieldConfig<RefuelStateItem>(
      type: FieldInputType.dateSetter,
      dateSetFieldConfig: refuelDateConfig,
      errorGetter: (s) => s.refuelDateError,
    ),
    CarInfoFieldConfig<RefuelStateItem>(
      type: FieldInputType.text,
      textConfig: FieldTextConfig(
        controller: litersController,
        isValid: draft.isLitersValid,
        hintText: "10",
        labelText: "مقدار افزوده",
        error: draft.litersError,
        isNumberOnly: true,
        onChanged: ref.setRawLiters,
      ),
    ),
    CarInfoFieldConfig<RefuelStateItem>(
      type: FieldInputType.picker,
      pickerConfig: refuelPaymentMethodConfig,
      errorGetter: (s) => s.refuelPaymentMethodError,
    ),
    CarInfoFieldConfig<RefuelStateItem>(
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
    CarInfoFieldConfig<RefuelStateItem>(
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

final litersController = TextEditingController();
final costController = TextEditingController();
final notesController = TextEditingController();

DateFieldConfig<RefuelStateItem> refuelDateConfig =
    DateFieldConfig<RefuelStateItem>(
      labelText: "تاریخ",
      getter: (state) => state.date,
      setter: (WidgetRef ref, value) {
        final current = ref.read(refuelDraftProvider);
        ref.read(refuelDraftProvider.notifier).state = current.copyWith(
          date: value,
          isDateInteractedOnce: true,
        );
      },
    );

PickerFieldConfig<RefuelStateItem> refuelPaymentMethodConfig =
    PickerFieldConfig<RefuelStateItem>(
      labelText: "روش پرداخت",
      providerBuilder: (state) => paymentMethodAsyncProvider,
      getter: (RefuelStateItem state) => state.paymentMethod,
      setter: (WidgetRef ref, PickerItem? value) {
        final current = ref.read(refuelDraftProvider);
        ref.read(refuelDraftProvider.notifier).state = current.copyWith(
          paymentMethod: value,
          ispaymentMethodInteractedOnce: true,
        );
      },
    );

final paymentMethodProvider = Provider<List<PickerItem>>(
  (ref) => [
    PickerItem(id: 'MARKET', title: 'آزاد'),
    PickerItem(id: 'SUBSIDIZED', title: 'سهمیه‌ای'),
  ],
);

final paymentMethodAsyncProvider = Provider<AsyncValue<List<PickerItem>>>((
  ref,
) {
  final list = ref.watch(paymentMethodProvider);
  return AsyncValue.data(list);
});
