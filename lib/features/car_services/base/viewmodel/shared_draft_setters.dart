import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/core/services/farsi_or_english_digits_input_formatter.dart';

// ---------- Broad field-set interfaces ----------

abstract class CostSetters<T> {
  T copyWith({int? cost, String? rawCostInput});
}

abstract class NotesSetters<T> {
  T copyWith({String? notes});
}

abstract class KilometerSetters<T> {
  T copyWith({int? kilometer, String? rawKilometerInput});
}

abstract class LocationSetters<T> {
  T copyWith({String? location});
}

abstract class PartSetters<T> {
  T copyWith({String? part});
}

extension DraftFieldSetters on WidgetRef {
  void setPart<T extends PartSetters<T>>(
    StateProvider<T> provider,
    String value,
  ) {
    update(provider, (s) => s.copyWith(part: value));
  }

  void setKilometerField<T extends KilometerSetters<T>>(
    StateProvider<T> provider,
    String input, {
    int? min,
    int? max,
  }) {
    final normalized =
        FarsiOrEnglishDigitsInputFormatter.normalizePersianDigits(input);
    final parsed = int.tryParse(normalized);
    final valid =
        parsed != null &&
        (min == null || parsed >= min) &&
        (max == null || parsed <= max);
    update(
      provider,
      (s) => s.copyWith(
        rawKilometerInput: input,
        kilometer: valid ? parsed : null,
      ),
    );
  }

  void setCostField<T extends CostSetters<T>>(
    StateProvider<T> provider,
    String input, {
    int? min,
    int? max,
  }) {
    final normalized =
        FarsiOrEnglishDigitsInputFormatter.normalizePersianDigits(input);
    final parsed = int.tryParse(normalized);
    final valid =
        parsed != null &&
        (min == null || parsed >= min) &&
        (max == null || parsed <= max);
    update(
      provider,
      (s) => s.copyWith(rawCostInput: input, cost: valid ? parsed : null),
    );
  }

  void setLocation<T extends LocationSetters<T>>(
    StateProvider<T> provider,
    String value,
  ) {
    update(provider, (s) => s.copyWith(location: value));
  }

  void setNotes<T extends NotesSetters<T>>(
    StateProvider<T> provider,
    String value,
  ) {
    update(provider, (s) => s.copyWith(notes: value));
  }

  // ---------- Internal helper ----------
  void update<T>(StateProvider<T> provider, T Function(T) transform) {
    final current = read(provider);
    read(provider.notifier).state = transform(current);
  }
}
