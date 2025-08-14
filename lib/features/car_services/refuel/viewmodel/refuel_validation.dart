import 'package:motogen/core/services/farsi_or_english_digits_input_formatter.dart';
import 'package:motogen/features/car_services/refuel/model/refuel_state_item.dart';

extension RefuelValidation on RefuelStateItem {
  String? get litersError {
    if (rawLitersInput == null || rawLitersInput!.trim().isEmpty) {
      return 'الزامی';
    }
    final normalized =
        FarsiOrEnglishDigitsInputFormatter.normalizePersianDigits(
          rawLitersInput!,
        );
    final parsed = double.tryParse(normalized);
    if (parsed == null || parsed < 1 || parsed > 100) {
      return 'مقدار باید بین 1 تا 100 لیتر باشد';
    }
    return null;
  }

  bool get isLitersValid => litersError == null;

  String? get costError {
    if (rawCostInput == null || rawCostInput!.trim().isEmpty) {
      return 'الزامی';
    }
    final normalized =
        FarsiOrEnglishDigitsInputFormatter.normalizePersianDigits(
          rawCostInput!,
        );
    final parsed = double.tryParse(normalized);
    if (parsed == null || parsed < 1500 || parsed > 10000000) {
      return 'هزینه باید بین 1,500 تا 10,000,000 باشد';
    }
    return null;
  }

  bool get isCostValid => costError == null;

  String? get notesError {
    if (notes == null || notes!.trim().isEmpty) return null;
    if (notes!.length > 5000) {
      return 'حداکثر طول متن 5000 کاراکتر است';
    }
    return null;
  }

  bool get isNoteValid => notesError == null;
}
