import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/core/services/farsi_or_english_digits_input_formatter.dart';
import 'package:motogen/features/car_sevices/refuel/model/refuel_state_item.dart';
import 'package:motogen/features/car_sevices/refuel/view/add_refuel_screen.dart';

extension RefuelDraftSetters on WidgetRef {
  void updateDraft(RefuelStateItem Function(RefuelStateItem) updater) {
    final current = read(refuelDraftProvider);
    read(refuelDraftProvider.notifier).state = updater(current);
  }

  void setRawLiters(String input) {
    final normalized =
        FarsiOrEnglishDigitsInputFormatter.normalizePersianDigits(input);
    final parsed = double.tryParse(normalized);
    updateDraft(
      (draft) => draft.copyWith(
        rawLitersInput: input,
        liters: (parsed != null && parsed >= 1 && parsed <= 100)
            ? parsed
            : null,
      ),
    );
  }

  void setRawCost(String input) {
    final normalized =
        FarsiOrEnglishDigitsInputFormatter.normalizePersianDigits(input);
    final parsed = double.tryParse(normalized);
    updateDraft(
      (draft) => draft.copyWith(
        rawCostInput: input,
        cost: (parsed != null && parsed >= 1500 && parsed <= 10000000)
            ? parsed
            : null,
      ),
    );
  }

  void setRawNotes(String input) {
    updateDraft(
      (draft) => draft.copyWith(
        notes: input.length <= 5000 ? input : input.substring(0, 5000),
      ),
    );
  }
}
