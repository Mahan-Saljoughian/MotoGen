import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/car_services/base/model/service_model.dart';
import 'package:motogen/features/car_services/oil/viewmodel/oil_list_notifier.dart';

import 'package:motogen/features/car_services/refuel/viewmodel/refuel_list_notifier.dart';

import 'package:motogen/features/car_services/repair/viewmodel/repair_list_notifier.dart';
import 'package:motogen/features/home_screen/widget/service_navigator.dart';

AsyncNotifierProviderFamily<
  FamilyAsyncNotifier<List<ServiceModel>, String>,
  List<ServiceModel>,
  String
>
getServiceListProvider(ServiceTitle serviceTitle) {
  switch (serviceTitle) {
    case ServiceTitle.refuel:
      return refuelListProvider
          as AsyncNotifierProviderFamily<
            FamilyAsyncNotifier<List<ServiceModel>, String>,
            List<ServiceModel>,
            String
          >;
    case ServiceTitle.oil:
      return oilListProvider
          as AsyncNotifierProviderFamily<
            FamilyAsyncNotifier<List<ServiceModel>, String>,
            List<ServiceModel>,
            String
          >;
    case ServiceTitle.repair:
      return repairListProvider
          as AsyncNotifierProviderFamily<
            FamilyAsyncNotifier<List<ServiceModel>, String>,
            List<ServiceModel>,
            String
          >;
    case ServiceTitle.purchases:
      return refuelListProvider
          as AsyncNotifierProviderFamily<
            FamilyAsyncNotifier<List<ServiceModel>, String>,
            List<ServiceModel>,
            String
          >;
  }
}



final serviceMoreEnabledProvider = StateProvider.family<bool, String>(
  (ref, itemId) => false,
);
final serviceAnyMoreOpenProvider = Provider.family<bool, List<ServiceModel>>((
  ref,
  items,
) {
  for (final r in items) {
    if (ref.watch(serviceMoreEnabledProvider(r.id))) {
      return true;
    }
  }
  return false;
});

enum ServiceSortType { newest, oldest }

final serviceSortProvider = StateProvider<ServiceSortType>(
  (ref) => ServiceSortType.newest,
);
