import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/core/services/farsi_or_english_digits_input_formatter.dart';

import 'package:motogen/features/car_services/refuel/model/refuel_state_item.dart';
import 'package:motogen/features/car_services/refuel/viewmodel/refuel_draft_setters.dart';



extension RefuelValidation on RefuelStateItem {
  String? get litersError {
    if (rawLitersInput == null || rawLitersInput!.trim().isEmpty) {
      return 'الزامی';
    }
    final normalized =
        FarsiOrEnglishDigitsInputFormatter.normalizePersianDigits(
          rawLitersInput!,
        );
    final parsed = int.tryParse(normalized);
    if (parsed == null || parsed < 1 || parsed > 100) {
      return 'مقدار باید بین 1 تا 100 لیتر باشد';
    }
    return null;
  }

  bool get isLitersValid => litersError == null;

}

// Local provider for refuel button logic
final isRefuelInfoButtonEnabled = Provider<bool>((ref) {
  final refuelState = ref.watch(refuelDraftProvider);
  return refuelState.isLitersValid &&
      refuelState.isCostValid &&
      refuelState.isNoteValid &&
      refuelState.date != null &&
      refuelState.liters != null &&
      refuelState.paymentMethod != null &&
      refuelState.cost != null;
});


