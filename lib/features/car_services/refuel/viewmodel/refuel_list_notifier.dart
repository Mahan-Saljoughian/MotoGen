import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/car_services/base/data/providers.dart';
import 'package:motogen/features/car_services/base/model/service_model.dart';
import 'package:motogen/features/car_services/refuel/model/refuel_state_item.dart';
import 'package:motogen/features/car_services/refuel/viewmodel/refuel_use_case_api.dart';

final refuelListProvider =
    AsyncNotifierProvider.family<
      RefuelListNotifier,
      List<RefuelStateItem>,
      String
    >(RefuelListNotifier.new);

class RefuelListNotifier
    extends ServiceListNotifier<RefuelStateItem> {
  @override
  Future<List<RefuelStateItem>> build(String carId) async {
    final currentSort = ref.watch(serviceSortProvider);
    return await fetchAllRefuels(carId, currentSort);
  }

  void deleteRefuelById(String refuelId) {
    state = state.whenData(
      (items) => items.where((r) => r.refuelId != refuelId).toList(),
    );
  }

}
