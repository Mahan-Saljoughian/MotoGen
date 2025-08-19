import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/car_services/base/viewmodel/shared_draft_setters.dart';
import 'package:motogen/features/car_services/oil/model/oil_state_item.dart';

final oillDraftProvider = StateProvider<OilStateItem>(
  (ref) => OilStateItem(oilId: "oil_temp_id"),
);

extension OilDraftSetters on WidgetRef {
  void updateDraft(OilStateItem Function(OilStateItem) updater) {
    final current = read(oillDraftProvider);
    read(oillDraftProvider.notifier).state = updater(current);
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
    setKilometerField(oillDraftProvider, input, min: 1, max: 10000000);
  }

  void setRawLocation(String input) {
    setLocation(oillDraftProvider, input);
  }

  void setRawCost(String input) {
    setCostField(oillDraftProvider, input, min: 1500, max: 10000000);
  }

  void setRawNotes(String input) {
    setNotes(oillDraftProvider, input);
  }
}
