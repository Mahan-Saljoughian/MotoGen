import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:motogen/features/car_services/base/viewmodel/shared_draft_setters.dart';
import 'package:motogen/features/car_services/repair/model/repair_state_item.dart';

final repairDraftProvider = StateProvider<RepairStateItem>(
  (ref) => RepairStateItem(repairId: "repair_temp_id"),
);

extension RepairDraftSetters on WidgetRef {
  void updateDraft(RepairStateItem Function(RepairStateItem) updater) {
    final current = read(repairDraftProvider);
    read(repairDraftProvider.notifier).state = updater(current);
  }

  void setRawPart(String input) {
    setPart(repairDraftProvider, input);
  }

  void setRawKilometer(String input) {
    setKilometerField(repairDraftProvider, input, min: 1, max: 10000000);
  }

  void setRawLocation(String input) {
    setLocation(repairDraftProvider, input);
  }

  void setRawCost(String input) {
    setCostField(repairDraftProvider, input, min: 1);
  }

  void setRawNotes(String input) {
    setNotes(repairDraftProvider, input);
  }
}
