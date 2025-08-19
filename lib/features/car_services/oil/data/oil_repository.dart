import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/car_services/base/data/base_service_repository.dart';
import 'package:motogen/features/car_services/oil/model/oil_state_item.dart';

class OilRepository extends BaseServiceRepository<OilStateItem> {
  @override
  String get endpoint => 'oil-changes';

  @override
  Map<String, dynamic> toApiJson(OilStateItem item) => item.toApiJson();
}

enum OilTypeTab { engine, gearbox, brake, steering }

final oilTypeTabProvider = StateProvider<OilTypeTab>(
  (ref) => OilTypeTab.engine,
);

String getOilTypeTabString(OilTypeTab oilTypetab) {
  return switch (oilTypetab) {
    OilTypeTab.engine => "ENGINE",
    OilTypeTab.gearbox => "GEARBOX",
    OilTypeTab.brake => "BRAKE",
    OilTypeTab.steering => "STEERING",
  };
}
