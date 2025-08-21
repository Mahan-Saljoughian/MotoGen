import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/car_services/base/data/providers.dart';


import 'package:motogen/features/car_services/base/model/service_model.dart';
import 'package:motogen/features/car_services/purchases/model/purhcase_state_item.dart';
import 'package:motogen/features/car_services/purchases/viewmodel/purchase_use_case_api.dart';



final purchaseListProvider =
    AsyncNotifierProvider.family<
      PurchaseListNotifier,
      List<PurhcaseStateItem>,
      String
    >(PurchaseListNotifier.new);

class PurchaseListNotifier extends ServiceListNotifier<PurhcaseStateItem> {
  @override
  Future<List<PurhcaseStateItem>> build(String carId) async {
       final currentSort = ref.watch(serviceSortProvider);
    return await fetchAllPurchases(carId, currentSort);

  }

  void deletepurchaseById(String purchaseId) {
    state = state.whenData(
      (items) => items.where((r) => r.purchaseId != purchaseId).toList(),
    );
  }
}
