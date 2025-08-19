import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/car_services/base/data/providers.dart';
import 'package:motogen/features/car_services/base/model/service_model.dart';
import 'package:motogen/features/car_services/oil/data/oil_repository.dart';
import 'package:motogen/features/car_services/oil/model/oil_state_item.dart';
import 'package:motogen/features/car_services/oil/viewmodel/oil_use_case_api.dart';

final oilListProvider =
    AsyncNotifierProvider.family<OilListNotifier, List<OilStateItem>, String>(
      OilListNotifier.new,
    );

class OilListNotifier extends ServiceListNotifier<OilStateItem> {
  @override
  Future<List<OilStateItem>> build(String carId) async {
    final currentSort = ref.watch(serviceSortProvider);
    final currentOilTypeTab = ref.watch(oilTypeTabProvider);
    return await fetchAllOils(carId, currentSort, currentOilTypeTab);
  }

  void deleteOilById(String oilId) {
    state = state.whenData(
      (items) => items.where((r) => r.oilId != oilId).toList(),
    );
  }
}
