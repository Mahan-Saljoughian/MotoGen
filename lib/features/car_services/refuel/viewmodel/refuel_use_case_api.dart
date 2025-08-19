import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:motogen/features/car_services/base/data/providers.dart';
import 'package:motogen/features/car_services/refuel/config/refuel_info_list.dart';
import 'package:motogen/features/car_services/refuel/data/refuel_repository.dart';
import 'package:motogen/features/car_services/refuel/model/refuel_state_item.dart';
import 'package:motogen/features/car_services/refuel/viewmodel/refuel_list_notifier.dart';

extension RefuelUseCaseApi on RefuelListNotifier {
  RefuelRepository get _refuelRepository => RefuelRepository();

  Future<List<RefuelStateItem>> fetchAllRefuels(
    String carId,
    ServiceSortType sortType,
  ) async {
    final sortQuery = sortType == ServiceSortType.oldest ? "asc" : "desc";
    final refuelsData = await _refuelRepository.getAllItems(
      carId,
      sortQuery,
      null,
    );
    final paymentMethods = ref.read(paymentMethodProvider);
    return refuelsData
        .map((refuel) => RefuelStateItem.fromApiJson(refuel, paymentMethods))
        .toList();
  }

  Future<void> addRefuelFromDraft(RefuelStateItem draft, String carId) async {
    try {
      await _refuelRepository.postItem(draft, carId);
    } catch (e) {
      debugPrint("debug Error adding refuel info for carId : $carId");
      rethrow;
    }
  }

  Future<void> deleteSelectedRefuelItemById(
    String carId,
    String refuelId,
  ) async {
    try {
      await _refuelRepository.deleteItemById(carId, refuelId);
      deleteRefuelById(refuelId);
    } catch (e, st) {
      Logger().e(
        "Error deleting refuel (id: $refuelId) for car $carId , error : $e , stacktrace: $st",
      );
      rethrow;
    }
  }

  Future<void> updateRefuelFromDraft(
    RefuelStateItem draft,
    RefuelStateItem original,
    String carId,
  ) async {
    // Build patch payload only for fields that have changed
    final Map<String, dynamic> changes = {};

    if (draft.liters != original.liters) changes['liters'] = draft.liters;
    if (draft.cost != original.cost) changes['cost'] = draft.cost;
    if (draft.paymentMethod?.id != original.paymentMethod?.id) {
      changes['paymentMethod'] = draft.paymentMethod?.id;
    }
    if (draft.date != original.date) {
      changes['date'] = draft.date?.toIso8601String();
    }
    if (draft.notes != original.notes) changes['notes'] = draft.notes;

    if (changes.isEmpty) {
      // Nothing changed, skip request
      return;
    }
    try {
      await _refuelRepository.patchItemById(changes, carId, original.refuelId!);
    } catch (e, st) {
      Logger().e(
        "Error patching refuel (id: ${original.refuelId}) for car $carId with ${changes.toString()}, error : $e , stacktrace: $st",
      );
      rethrow;
    }
  }
}
