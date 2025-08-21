import 'package:motogen/core/services/farsi_or_english_digits_input_formatter.dart';
import 'package:motogen/core/services/format_functions.dart';

// ---------- Validation mixins ----------

mixin DateValidationForService {
  bool? get isDateInteractedOnce;
  DateTime? get date;
  String? get dateError =>
      isDateInteractedOnce! && date == null ? 'الزامی!' : null;

  bool get isDateValid => dateError == null;
}

mixin CostValidation {
  String? get rawCostInput;
  int? get cost;

  int get costMin;
  int get costMax;

  String? get costError {
    if (rawCostInput == null || rawCostInput!.trim().isEmpty) {
      return 'الزامی';
    }
    final normalized =
        FarsiOrEnglishDigitsInputFormatter.normalizePersianDigits(
          rawCostInput!,
        );
    final parsed = int.tryParse(normalized);
    if (parsed == null || parsed < costMin || parsed > costMax) {
      return 'هزینه باید بین ${formatNumberByThreeDigit(costMin)} تا ${formatNumberByThreeDigit(costMax)} باشد';
    }
    return null;
  }

  bool get isCostValid => costError == null;
}

mixin NotesValidation {
  String? get notes;
  String? get notesError {
    if (notes == null || notes!.trim().isEmpty) return null;
    if (notes!.length > 5000) {
      return 'حداکثر طول متن 5000 کاراکتر است';
    }
    return null;
  }

  bool get isNoteValid => notesError == null;
}

mixin KilometerValidation {
  String? get rawKilometerInput;
  int? get kilometer;
  String? get kilometerError {
    if (rawKilometerInput == null || rawKilometerInput!.trim().isEmpty) {
      return 'الزامی';
    }
    final normalized =
        FarsiOrEnglishDigitsInputFormatter.normalizePersianDigits(
          rawKilometerInput!,
        );
    final parsed = int.tryParse(normalized);
    if (parsed == null || parsed < 1 || parsed > 10000000) {
      return 'مقدار باید بین 1 تا 10,000,000 کیلومتر باشد';
    }
    return null;
  }

  bool get isKilometerValid => kilometerError == null;
}

mixin LocationValidation {
  String? get location;
  String? get locationError {
    if (location == null || location!.trim().isEmpty) {
      return 'الزامی';
    }
    if (location!.length > 100) {
      return 'حداکثر طول متن 100 کاراکتر است';
    }
    return null;
  }

  bool get isLocationValid => locationError == null;
}

mixin PartValidation {
  String? get part;
  String? get partError {
    if (part == null || part!.trim().isEmpty) {
      return 'الزامی';
    }
    if (part!.length > 100) {
      return 'حداکثر طول متن 100 کاراکتر است';
    }
    return null;
  }

  bool get isPartValid => partError == null;
}
