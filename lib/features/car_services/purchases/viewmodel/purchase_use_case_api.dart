import 'package:flutter/foundation.dart';
import 'package:motogen/core/services/logger.dart';
import 'package:motogen/features/car_services/base/data/providers.dart';
import 'package:motogen/features/car_services/purchases/config/purchase_info_list.dart';
import 'package:motogen/features/car_services/purchases/data/purchase_repository.dart';
import 'package:motogen/features/car_services/purchases/model/purhcase_state_item.dart';
import 'package:motogen/features/car_services/purchases/viewmodel/purchase_list_notifier.dart';

extension PurchaseUseCaseApi on PurchaseListNotifier {
  PurchaseRepository get _purchasesRepository => PurchaseRepository();

  Future<List<PurhcaseStateItem>> fetchAllPurchases(
    String carId,
    ServiceSortType sortType,
  ) async {
    final sortQuery = sortType == ServiceSortType.oldest ? "asc" : "desc";
    final purchasesData = await _purchasesRepository.getAllItems(
      carId,
      sortQuery,
      null,
    );
    final purchaseCategories = ref.read(purchaseCategoryProvider);
    return purchasesData
        .map(
          (purchase) =>
              PurhcaseStateItem.fromApiJson(purchase, purchaseCategories),
        )
        .toList();
  }

  Future<void> addPurchaseFromDraft(
    PurhcaseStateItem draft,
    String carId,
  ) async {
    try {
      await _purchasesRepository.postItem(draft, carId);
    } catch (e) {
      debugPrint("debug Error adding purchase info for carId : $carId");
      rethrow;
    }
  }

  Future<void> deleteSelectedPurchaseItemById(
    String carId,
    String purchaseId,
  ) async {
    try {
      await _purchasesRepository.deleteItemById(carId, purchaseId);
      deletepurchaseById(purchaseId);
    } catch (e, st) {
      appLogger.e(
        "Error deleting purchase (id: $purchaseId) for car $carId , error : $e , stacktrace: $st",
      );
      rethrow;
    }
  }

  Future<void> updatePurchaseFromDraft(
    PurhcaseStateItem draft,
    PurhcaseStateItem original,
    String carId,
  ) async {
    // Build patch payload only for fields that have changed
    final Map<String, dynamic> changes = {};
    if (draft.date != original.date) {
      changes['date'] = draft.date?.toIso8601String();
    }
    if (draft.part != original.part) changes['part'] = draft.part;
    if (draft.purchaseCategory?.id != original.purchaseCategory?.id) {
      changes['purchaseCategory'] = draft.purchaseCategory?.id;
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
      await _purchasesRepository.patchItemById(
        changes,
        carId,
        original.purchaseId!,
      );
    } catch (e, st) {
      appLogger.e(
        "Error patching purchase (id: ${original.purchaseId}) for car $carId with ${changes.toString()}, error : $e , stacktrace: $st",
      );
      rethrow;
    }
  }
}
