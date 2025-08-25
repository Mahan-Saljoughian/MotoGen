import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:motogen/features/car_services/base/viewmodel/shared_draft_setters.dart';
import 'package:motogen/features/car_services/purchases/model/purhcase_state_item.dart';


final purchaseDraftProvider = StateProvider<PurhcaseStateItem>(
  (ref) => PurhcaseStateItem(purchaseId: "purchase_temp_id"),
);

extension PurchaseDraftSetters on WidgetRef {
  

  void setRawPart(String input) {
    setPart(purchaseDraftProvider, input);
  }

  void setRawLocation(String input) {
    setLocation(purchaseDraftProvider, input);
  }

  void setRawCost(String input) {
    setCostField(purchaseDraftProvider, input, min: 1, max: 1000000000);
  }

  void setRawNotes(String input) {
    setNotes(purchaseDraftProvider, input);
  }
}
