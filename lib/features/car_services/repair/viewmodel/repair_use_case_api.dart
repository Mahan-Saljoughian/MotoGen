import 'package:flutter/foundation.dart';
import 'package:motogen/core/services/logger.dart';
import 'package:motogen/features/car_services/base/data/providers.dart';
import 'package:motogen/features/car_services/repair/config/repair_info_list.dart';
import 'package:motogen/features/car_services/repair/data/repair_repository.dart';
import 'package:motogen/features/car_services/repair/model/repair_state_item.dart';
import 'package:motogen/features/car_services/repair/viewmodel/repair_list_notifier.dart';

extension RepairUseCaseApi on RepairListNotifier {
  RepairRepository get _repairRepository => RepairRepository();

  Future<List<RepairStateItem>> fetchAllRepairs(
    String carId,
    ServiceSortType sortType,
  ) async {
    final sortQuery = sortType == ServiceSortType.oldest ? "asc" : "desc";
    final repairsData = await _repairRepository.getAllItems(
      carId,
      sortQuery,
      null,
    );
    final paymentMethods = ref.read(repairActionProvider);
    return repairsData
        .map((repair) => RepairStateItem.fromApiJson(repair, paymentMethods))
        .toList();
  }

  Future<void> addRepairFromDraft(RepairStateItem draft, String carId) async {
    try {
      await _repairRepository.postItem(draft, carId);
    } catch (e) {
      debugPrint("debug Error adding repair info for carId : $carId");
      rethrow;
    }
  }

  Future<void> deleteSelectedRepairItemById(
    String carId,
    String repairId,
  ) async {
    try {
      await _repairRepository.deleteItemById(carId, repairId);
      deleteRepairById(repairId);
    } catch (e, st) {
      appLogger.e(
        "Error deleting repair (id: $repairId) for car $carId , error : $e , stacktrace: $st",
      );
      rethrow;
    }
  }

  Future<void> updateRepairFromDraft(
    RepairStateItem draft,
    RepairStateItem original,
    String carId,
  ) async {
    // Build patch payload only for fields that have changed
    final Map<String, dynamic> changes = {};
    if (draft.date != original.date) {
      changes['date'] = draft.date?.toIso8601String();
    }
    if (draft.part != original.part) changes['part'] = draft.part;
    if (draft.repairAction?.id != original.repairAction?.id) {
      changes['repairAction'] = draft.repairAction?.id;
    }

    if (draft.kilometer != original.kilometer) {
      changes['kilometer'] = draft.kilometer;
    }

    if (draft.location != original.location) {
      changes['location'] = draft.location;
    }
    if (draft.cost != original.cost) changes['cost'] = draft.cost;
    if (draft.notes != original.notes) changes['notes'] = draft.notes;

    if (changes.isEmpty) {
      // Nothing changed, skip request
      return;
    }
    try {
      await _repairRepository.patchItemById(changes, carId, original.repairId!);
    } catch (e, st) {
      appLogger.e(
        "Error patching repair (id: ${original.repairId}) for car $carId with ${changes.toString()}, error : $e , stacktrace: $st",
      );
      rethrow;
    }
  }
}
