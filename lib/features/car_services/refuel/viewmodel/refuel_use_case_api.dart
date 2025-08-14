import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:motogen/features/bottom_sheet/config/picker_item.dart';
import 'package:motogen/features/car_services/refuel/config/refuel_info_list.dart';
import 'package:motogen/features/car_services/refuel/data/refuel_repository.dart';
import 'package:motogen/features/car_services/refuel/model/refuel_state_item.dart';
import 'package:motogen/features/car_services/refuel/viewmodel/refuel_list_notifier.dart';

extension RefuelUseCaseApi on RefuelListNotifier {
  RefuelRepository get _refuelRepository => RefuelRepository();

  Future<List<RefuelStateItem>> fetchAllRefuels(String carId) async {
    final refuelsData = await _refuelRepository.getALLRefuels(carId);
    final paymentMethods = ref.read(paymentMethodProvider);
    return refuelsData.map((refuel) {
      return RefuelStateItem(
        refuelId: refuel["id"],
        date: DateTime.parse(refuel["date"] as String), //tolocal()
        liters: (refuel["liters"] as num).toDouble(),
        cost: (refuel["cost"] as num).toDouble(),
        paymentMethod: paymentMethods.firstWhere(
          (payment) => payment.id == (refuel["paymentMethod"] ?? ''),
          orElse: () => PickerItem(
            id: refuel['paymentMethod'] ?? '',
            title: refuel['paymentMethod'] ?? '',
          ),
        ),
        notes: refuel['notes'],
      );
    }).toList();
  }

  Future<void> addRefuelFromDraft(RefuelStateItem draft, String carId) async {
    try {
      final response = await _refuelRepository.postRefuelInfo(draft, carId);
      final newRefuel = draft.copyWith(refuelId: response['data']['id']);
      addRefuel(newRefuel);
    } catch (e) {
      debugPrint("debug Error adding refuel info for carId : $carId");
      rethrow;
    }
  }

  Future<void> deleteSelectedRefuelItemById(String carId, String refuelId) async {
    try {
      final response = await _refuelRepository.deleteRefuelItemById(
        carId,
        refuelId,
      );

      if (response['success'] != true) {
        throw Exception(response['message'] ?? "Failed to delete car");
      }

      deleteRefuelById(refuelId);
    } catch (e, st) {
      Logger().e(
        "Error deleting refuel (id: $refuelId) for car $carId , error : $e , stacktrace: $st",
      );
      rethrow;
    }
  }

  /* Future<void> refresh([String? sortBy]) async {
  state = const AsyncLoading();
  state = await AsyncValue.guard(() async {
    var list = await _fetchFromApi(arg);
    if (sortBy != null) list = _sort(list, sortBy);
    return list;
  });
}

List<RefuelStateItem> _sort(List<RefuelStateItem> items, String sortBy) {
  final sorted = [...items];
  switch (sortBy) {
    case 'date':
      sorted.sort((a, b) => b.date!.compareTo(a.date!));
      break;
    case 'cost':
      sorted.sort((a, b) => b.cost!.compareTo(a.cost!));
      break;
  }
  return sorted;
} */
}
