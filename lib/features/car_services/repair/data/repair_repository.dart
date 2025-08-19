import 'package:motogen/features/car_services/base/data/base_service_repository.dart';
import 'package:motogen/features/car_services/repair/model/repair_state_item.dart';

class RepairRepository extends BaseServiceRepository<RepairStateItem> {
  @override
  String get endpoint => 'repairs';

  @override
  Map<String, dynamic> toApiJson(RepairStateItem item) => item.toApiJson();
}
