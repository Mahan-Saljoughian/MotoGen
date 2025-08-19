import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:motogen/features/car_services/base/data/providers.dart';
import 'package:motogen/features/car_services/oil/config/oil_info_list.dart';
import 'package:motogen/features/car_services/oil/data/oil_repository.dart';
import 'package:motogen/features/car_services/oil/model/oil_state_item.dart';
import 'package:motogen/features/car_services/oil/viewmodel/oil_list_notifier.dart';

extension OilUseCaseApi on OilListNotifier {
  OilRepository get _oilRepository => OilRepository();

  Future<List<OilStateItem>> fetchAllOils(
    String carId,
    ServiceSortType sortType,
    OilTypeTab oilTypeTab,
  ) async {
    final sortQuery = sortType == ServiceSortType.oldest ? "asc" : "desc";
    final oilTypeTabQuery = getOilTypeTabString(oilTypeTab);
    final oilData = await _oilRepository.getAllItems(
      carId,
      sortQuery,
      oilTypeTabQuery,
    );
    final oilTypes = ref.read(oilTypeProvider);
    return oilData
        .map((oil) => OilStateItem.fromApiJson(oil, oilTypes))
        .toList();
  }

  Future<void> addOilFromDraft(OilStateItem draft, String carId) async {
    try {
      await _oilRepository.postItem(draft, carId);
    } catch (e) {
      debugPrint("debug Error adding oil info for carId : $carId");
      rethrow;
    }
  }

  Future<void> deleteSelectedOilItemById(String carId, String oilId) async {
    try {
      await _oilRepository.deleteItemById(carId, oilId);
      deleteOilById(oilId);
    } catch (e, st) {
      Logger().e(
        "Error deleting oil (id: $oilId) for car $carId , error : $e , stacktrace: $st",
      );
      rethrow;
    }
  }

  Future<void> updateOilFromDraft(
    OilStateItem draft,
    OilStateItem original,
    String carId,
  ) async {
    // Build patch payload only for fields that have changed
    final Map<String, dynamic> changes = {};

    if (draft.date != original.date) {
      changes['date'] = draft.date?.toIso8601String();
    }
    /*    if (draft.oilType?.id != original.oilType?.id) {
      changes['oilType'] = draft.oilType?.id;
    } */
    if (draft.oilBrandAndModel != original.oilBrandAndModel) {
      changes['oilBrandAndModel'] = draft.oilBrandAndModel;
    }
    if (draft.kilometer != original.kilometer) {
      changes['kilometer'] = draft.kilometer;
    }
    if (draft.cost != original.cost) changes['cost'] = draft.cost;
    if (draft.location != original.location) {
      changes['location'] = draft.location;
    }
    if (draft.oilType?.id == "ENGINE") {
      if (draft.oilFilterChanged != original.oilFilterChanged) {
        changes['oilFilterChanged'] = draft.oilFilterChanged;
      }
      if (draft.airFilterChanged != original.airFilterChanged) {
        changes['airFilterChanged'] = draft.airFilterChanged;
      }
      if (draft.cabinFilterChanged != original.cabinFilterChanged) {
        changes['cabinFilterChanged'] = draft.cabinFilterChanged;
      }
      if (draft.fuelFilterChanged != original.fuelFilterChanged) {
        changes['fuelFilterChanged'] = draft.fuelFilterChanged;
      }
    }
    if (draft.notes != original.notes) changes['notes'] = draft.notes;

    if (changes.isEmpty) {
      // Nothing changed, skip request
      return;
    }
    try {
      await _oilRepository.patchItemById(changes, carId, original.oilId!);
    } catch (e, st) {
      Logger().e(
        "Error patching oil (id: ${original.oilId}) for car $carId with ${changes.toString()}, error : $e , stacktrace: $st",
      );
      rethrow;
    }
  }
}
