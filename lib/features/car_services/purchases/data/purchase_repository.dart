import 'package:motogen/features/car_services/base/data/base_service_repository.dart';
import 'package:motogen/features/car_services/purchases/model/purhcase_state_item.dart';

class PurchaseRepository extends BaseServiceRepository<PurhcaseStateItem> {
  @override
  String get endpoint => 'purchases';

  @override
  Map<String, dynamic> toApiJson(PurhcaseStateItem item) => item.toApiJson();
}
