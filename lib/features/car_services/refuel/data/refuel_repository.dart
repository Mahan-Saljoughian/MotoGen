
import 'package:motogen/features/car_services/base/data/base_service_repository.dart';
import 'package:motogen/features/car_services/refuel/model/refuel_state_item.dart';

class RefuelRepository extends BaseServiceRepository<RefuelStateItem> {
  @override
  String get endpoint => 'refuels';

  @override
  Map<String, dynamic> toApiJson(RefuelStateItem item) => item.toApiJson();
}