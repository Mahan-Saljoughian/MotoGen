import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/core/services/farsi_or_english_digits_input_formatter.dart';
import 'package:motogen/features/car_services/base/viewmodel/shared_draft_setters.dart';
import 'package:motogen/features/car_services/refuel/model/refuel_state_item.dart';

final refuelDraftProvider = StateProvider<RefuelStateItem>(
  (ref) => RefuelStateItem(refuelId: "refuel_temp_id"),
);

extension RefuelDraftSetters on WidgetRef {
  void updateDraft(RefuelStateItem Function(RefuelStateItem) updater) {
    final current = read(refuelDraftProvider);
    read(refuelDraftProvider.notifier).state = updater(current);
  }

  void setRawLiters(String input) {
    final normalized =
        FarsiOrEnglishDigitsInputFormatter.normalizePersianDigits(input);
    final parsed = int.tryParse(normalized);
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
    setCostField(refuelDraftProvider, input, min: 1500, max: 10000000);
  }

  void setRawNotes(String input) {
    setNotes(refuelDraftProvider, input);
  }
}
