import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/bottom_sheet/config/picker_item.dart';
import 'package:motogen/features/car_services/refuel/model/refuel_state_item.dart';
import 'package:motogen/features/car_services/refuel/viewmodel/refuel_use_case_api.dart';

final refuelListProvider =
    AsyncNotifierProvider.family<
      RefuelListNotifier,
      List<RefuelStateItem>,
      String
    >(RefuelListNotifier.new);

class RefuelListNotifier
    extends FamilyAsyncNotifier<List<RefuelStateItem>, String> {
  @override
  Future<List<RefuelStateItem>> build(String carId) async {
    return await fetchAllRefuels(carId);
  }

  void addRefuel(RefuelStateItem refuel) {
    state = state.whenData((items) => [...items, refuel]);
  }

  void updateRefuel(RefuelStateItem updated) {
    state = state.whenData(
      (items) => items
          .map((r) => r.refuelId == updated.refuelId ? updated : r)
          .toList(),
    );
  }

  void deleteRefuelById(String refuelId) {
    state = state.whenData(
      (items) => items.where((r) => r.refuelId != refuelId).toList(),
    );
  }

  RefuelStateItem? getRefuelById(String refuelId) {
    final items = state.valueOrNull;
    if (items == null) return null;

    final index = items.indexWhere((r) => r.refuelId == refuelId);
    return index == -1 ? null : items[index];
  }

  void createDraftRefuel() {
    final draft = RefuelStateItem(
      refuelId: "temp_id",
    ); // Temporary id for draft
    addRefuel(draft);
  }

  // --- Attribute Setters ---

  void setDate(String refuelId, DateTime? date) {
    final refuel = getRefuelById(refuelId);
    if (refuel != null) {
      updateRefuel(refuel.copyWith(date: date));
    }
  }

  void setPaymentMethod(String refuelId, PickerItem? paymentMethod) {
    final refuel = getRefuelById(refuelId);
    if (refuel != null) {
      updateRefuel(refuel.copyWith(paymentMethod: paymentMethod));
    }
  }

  void setLiters(String refuelId, double? liters) {
    final refuel = getRefuelById(refuelId);
    if (refuel != null) {
      updateRefuel(refuel.copyWith(liters: liters));
    }
  }

  void setCost(String refuelId, double? cost) {
    final refuel = getRefuelById(refuelId);
    if (refuel != null) {
      updateRefuel(refuel.copyWith(cost: cost));
    }
  }

  void setNotes(String refuelId, String? notes) {
    final refuel = getRefuelById(refuelId);
    if (refuel != null) {
      updateRefuel(refuel.copyWith(notes: notes));
    }
  }
}
