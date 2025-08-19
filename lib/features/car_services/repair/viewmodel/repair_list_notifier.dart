import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:motogen/features/car_services/base/data/providers.dart';
import 'package:motogen/features/car_services/base/model/service_model.dart';

import 'package:motogen/features/car_services/repair/model/repair_state_item.dart';
import 'package:motogen/features/car_services/repair/viewmodel/repair_use_case_api.dart';

final repairListProvider =
    AsyncNotifierProvider.family<
      RepairListNotifier,
      List<RepairStateItem>,
      String
    >(RepairListNotifier.new);

class RepairListNotifier extends ServiceListNotifier<RepairStateItem> {
  @override
  Future<List<RepairStateItem>> build(String carId) async {
    final currentSort = ref.watch(serviceSortProvider);
    return await fetchAllRepairs(carId, currentSort);
  }

  void deleteRepairById(String repairId) {
    state = state.whenData(
      (items) => items.where((r) => r.repairId != repairId).toList(),
    );
  }
}
