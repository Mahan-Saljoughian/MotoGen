import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/bottom_sheet/config/picker_item.dart';
import 'package:motogen/features/car_info/models/car_form_state_item.dart';
import 'package:motogen/features/car_services/base/viewmodel/shared_draft_setters.dart';

final carDraftProvider = StateProvider<CarFormStateItem>(
  (ref) => const CarFormStateItem(carId: 'car_temp_id'),
);

final nickNameControllerProvider = Provider.autoDispose<TextEditingController>((
  ref,
) {
  final draft = ref.read(carDraftProvider);
  final controller = TextEditingController(text: draft.nickName ?? '');
  ref.onDispose(controller.dispose);
  return controller;
});

extension CarDraftSetters on WidgetRef {
  void updateCarDraft(CarFormStateItem Function(CarFormStateItem) updater) {
    final current = read(carDraftProvider);
    read(carDraftProvider.notifier).state = updater(current);
  }

  void setBrand(PickerItem? brand) {
    updateCarDraft(
      (car) => car.copyWith(
        brand: brand,
        isBrandInteractedOnce: true,
        model: PickerItem.noValueString,
        type: PickerItem.noValueString,
        yearMade: PickerItem.yearNoValue,
      ),
    );
  }

  void setModel(PickerItem? model) {
    updateCarDraft(
      (car) => car.copyWith(
        model: model,
        isModelInteractedOnce: true,
        type: PickerItem.noValueString,
        yearMade: PickerItem.yearNoValue,
      ),
    );
  }

  void setType(PickerItem? type) {
    updateCarDraft(
      (car) => car.copyWith(
        type: type,
        isTypeInteractedOnce: true,
        yearMade: PickerItem.yearNoValue,
      ),
    );
  }

  void setYearMade(int? year) {
    updateCarDraft(
      (car) => car.copyWith(yearMade: year, isYearMadeInteractedOnce: true),
    );
  }

  void setColor(PickerItem? color) {
    updateCarDraft(
      (car) => car.copyWith(color: color, isColorInteractedOnce: true),
    );
  }

  void setRawKilometer(String input) {
    setKilometerField(carDraftProvider, input, min: 1, max: 10000000);
  }

  void setFuelType(PickerItem? fuel) {
    updateCarDraft(
      (car) => car.copyWith(fuelType: fuel, isFuelTypeInteractedOnce: true),
    );
  }

  void setBodyInsuranceExpiry(DateTime? date) {
    updateCarDraft(
      (car) => car.copyWith(
        bodyInsuranceExpiry: date,
        isBodyInsuranceExpiryInteractedOnce: true,
      ),
    );
  }

  void setNextTechnicalCheck(DateTime? date) {
    updateCarDraft(
      (car) => car.copyWith(
        nextTechnicalCheck: date,
        isNextTechnicalCheckInteractedOnce: true,
      ),
    );
  }

  void setThirdPersonInsuranceExpiry(DateTime? date) {
    updateCarDraft(
      (car) => car.copyWith(
        thirdPartyInsuranceExpiry: date,
        isThirdPartyInsuranceExpiryInteractedOnce: true,
      ),
    );
  }

  void setNickName(String? input) {
    updateCarDraft((draft) => draft.copyWith(nickName: input));
  }
}
