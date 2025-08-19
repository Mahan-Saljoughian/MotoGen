import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:motogen/features/home_screen/widget/service_navigator.dart';

abstract class ServiceModel {
  String get id;
  List<String> getTitleByIndex();
  List<String> getValueByIndex();
  List<String> getTitleByIndexForMoreItems();
  List<String> getValueByIndexForMoreItems();
  String? get serviceNotes;
}

abstract class ServiceListNotifier<T extends ServiceModel>
    extends FamilyAsyncNotifier<List<T>, String> {}

String getServiceTitle(ServiceTitle serviceTitle) {
  return switch (serviceTitle) {
    ServiceTitle.refuel => "سوخت",
    ServiceTitle.oil => "روغن",
    ServiceTitle.repair => "تعمیرات",
    ServiceTitle.purchases => "خرید",
  };
}
