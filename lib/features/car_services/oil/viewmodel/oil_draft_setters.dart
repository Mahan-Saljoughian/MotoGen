import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/car_services/base/viewmodel/shared_draft_setters.dart';
import 'package:motogen/features/car_services/oil/model/oil_state_item.dart';

final oilDraftProvider = StateProvider<OilStateItem>(
  (ref) => OilStateItem(oilId: "oil_temp_id"),
);

extension OilDraftSetters on WidgetRef {
  void updateDraft(OilStateItem Function(OilStateItem) updater) {
    final current = read(oilDraftProvider);
    read(oilDraftProvider.notifier).state = updater(current);
  }

  void setRawOilBrandAndModel(String oilBrandAndModel) {
    updateDraft((draft) => draft.copyWith(oilBrandAndModel: oilBrandAndModel));
  }

  void setRawOilFilterChanged(bool oilFilterChanged) {
    updateDraft((draft) => draft.copyWith(oilFilterChanged: oilFilterChanged));
  }

  void setRawAirFilterChanged(bool airFilterChanged) {
    updateDraft((draft) => draft.copyWith(airFilterChanged: airFilterChanged));
  }

  void setRawCabinFilterChanged(bool cabinFilterChanged) {
    updateDraft(
      (draft) => draft.copyWith(cabinFilterChanged: cabinFilterChanged),
    );
  }

  void setRawFuelFilterChanged(bool fuelFilterChanged) {
    updateDraft(
      (draft) => draft.copyWith(fuelFilterChanged: fuelFilterChanged),
    );
  }

  void setRawKilometer(String input) {
    setKilometerField(oilDraftProvider, input, min: 1, max: 10000000);
  }

  void setRawLocation(String input) {
    setLocation(oilDraftProvider, input);
  }

  void setRawCost(String input) {
    setCostField(oilDraftProvider, input, min: 1, max: 1000000000);
  }

  void setRawNotes(String input) {
    setNotes(oilDraftProvider, input);
  }
}
