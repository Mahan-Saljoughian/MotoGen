import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/car_services/oil/model/oil_state_item.dart';
import 'package:motogen/features/car_services/oil/viewmodel/oil_draft_setters.dart';

extension RefuelValidation on OilStateItem {
  String? get oilBrandAndModelError {
    if (oilBrandAndModel == null || oilBrandAndModel!.trim().isEmpty) {
      return 'الزامی';
    }
    if (oilBrandAndModel!.length > 100) {
      return 'حداکثر طول متن 100 کاراکتر است';
    }
    return null;
  }

  bool get isoilBrandAndModelValid => oilBrandAndModelError == null;
}

// Local provider for refuel button logic
final isOilInfoButtonEnabled = Provider.family<bool, bool>((ref, isEdit) {
  final oilState = ref.watch(oillDraftProvider);
  final baseCheck =
      oilState.isoilBrandAndModelValid &&
      oilState.isKilometerValid &&
      oilState.isLocationValid &&
      oilState.isCostValid &&
      oilState.isNoteValid &&
      oilState.date != null &&
      oilState.oilBrandAndModel != null &&
      oilState.kilometer != null &&
      oilState.location != null &&
      oilState.cost != null;
  return isEdit ? baseCheck : baseCheck && oilState.oilType != null;
});
