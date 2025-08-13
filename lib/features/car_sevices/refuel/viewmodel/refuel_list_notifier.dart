import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/bottom_sheet/config/picker_item.dart';
import 'package:motogen/features/car_sevices/refuel/model/refuel_state_item.dart';

final refuelListProvider =
    NotifierProvider.family<RefuelListNotifier, List<RefuelStateItem>, String>(
      RefuelListNotifier.new,
    );

class RefuelListNotifier extends FamilyNotifier<List<RefuelStateItem>, String> {
  @override
  List<RefuelStateItem> build(String carId) {
    // Load from backend/local if needed
    return [];
  }

  void addRefuel(RefuelStateItem refuel) {
    state = [...state, refuel];
  }

  void updateRefuel(RefuelStateItem updated) {
    state = [
      for (final r in state)
        if (r.refuelId == updated.refuelId) updated else r,
    ];
  }

  void deleteRefuel(String refuelId) {
    state = state.where((r) => r.refuelId != refuelId).toList();
  }

  RefuelStateItem? getRefuelById(String refuelId) {
    final index = state.indexWhere((r) => r.refuelId == refuelId);
    return index == -1 ? null : state[index];
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
