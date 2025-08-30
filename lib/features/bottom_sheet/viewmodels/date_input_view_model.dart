import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/core/services/farsi_or_english_digits_input_formatter.dart';
import 'package:motogen/features/bottom_sheet/config/date_field_config.dart';
import 'package:shamsi_date/shamsi_date.dart';

class DateInputViewModel extends ChangeNotifier {
  final DateUsageType usageType;
  DateInputViewModel({required this.usageType});

  String _day = '';
  String _month = '';
  String _year = '';

  bool _dayValid = false;
  bool _monthValid = false;
  bool _yearValid = false;

  String get day => _day;
  String get month => _month;
  String get year => _year;

  final Jalali nowJalali = Jalali.now();
  String get dayHint => nowJalali.day.toString();
  String get monthHint => nowJalali.month.toString();
  String get yearHint => nowJalali.year.toString();

  DateTime get gergorianNow => DateTime.now();

  bool isDayInteractedOnce = false;
  bool isMonthInteractedOnce = false;
  bool isYearInteractedOnce = false;

  void markDayInteracted() {
    isDayInteractedOnce = true;
    notifyListeners();
  }

  void markMonthInteracted() {
    isMonthInteractedOnce = true;
    notifyListeners();
  }

  void markYearInteracted() {
    isYearInteractedOnce = true;
    notifyListeners();
  }

  void setDay(String value) {
    _day = FarsiOrEnglishDigitsInputFormatter.normalizePersianDigits(value);
    _dayValid = _isNumberInRange(_day, 1, 31) && _day.isNotEmpty;
    notifyListeners();
  }

  void setMonth(String value) {
    _month = FarsiOrEnglishDigitsInputFormatter.normalizePersianDigits(value);
    _monthValid = _isNumberInRange(_month, 1, 12) && _month.isNotEmpty;
    notifyListeners();
  }

  void setYear(String value) {
    _year = FarsiOrEnglishDigitsInputFormatter.normalizePersianDigits(value);
    _yearValid = (_year.length == 4) && _year.startsWith('14');
    notifyListeners();
  }

  DateTime? _asDateTimeWithNow(DateTime nowUtc) {
    if (!_isFieldsValid) return null;
    try {
      final baseGregorian = Jalali(
        int.parse(_year),
        int.parse(_month),
        int.parse(_day),
      ).toDateTime();

      if (usageType == DateUsageType.services) {
        final nowLocal = nowUtc.toLocal();
        final localDateTime = DateTime(
          baseGregorian.year,
          baseGregorian.month,
          baseGregorian.day,
          nowLocal.hour,
          nowLocal.minute,
          nowLocal.second,
        );
        return localDateTime.toUtc();
      }
      return baseGregorian;
    } catch (_) {
      return null;
    }
  }

  DateTime? asDateTime() {
    return _asDateTimeWithNow(DateTime.now().toUtc());
  }

  bool isDateValid() {
    if (!_isFieldsValid) return false;

    final nowUtc = DateTime.now().toUtc();
    final truncatedNowUtc = DateTime.utc(
      nowUtc.year,
      nowUtc.month,
      nowUtc.day,
      nowUtc.hour,
      nowUtc.minute,
      nowUtc.second,
    );
    final date = _asDateTimeWithNow(truncatedNowUtc);
    if (date == null) return false;

    switch (usageType) {
      case DateUsageType.insurance:
        final maxDate = truncatedNowUtc.add(const Duration(days: 366));
        return date.isBefore(maxDate);
      case DateUsageType.services:
        return date.isBefore(truncatedNowUtc) ||
            date.isAtSameMomentAs(truncatedNowUtc);
    }
  }

  bool get dayValid => _dayValid;
  bool get monthValid => _monthValid;
  bool get yearValid => _yearValid;

  bool get _isFieldsValid => _dayValid && _monthValid && _yearValid;
  bool get isFieldsValid => _isFieldsValid;

  String errorText() {
    if (!_isFieldsValid) return "تاریخ معتبر انتخاب کن";
    final nowUtc = DateTime.now().toUtc();
    final truncatedNowUtc = DateTime.utc(
      nowUtc.year,
      nowUtc.month,
      nowUtc.day,
      nowUtc.hour,
      nowUtc.minute,
      nowUtc.second,
    );
    final date = _asDateTimeWithNow(truncatedNowUtc);
    if (date == null) return "تاریخ معتبر انتخاب کن";

    switch (usageType) {
      case DateUsageType.insurance:
        final maxDate = truncatedNowUtc.add(const Duration(days: 366));
        if (!date.isBefore(maxDate)) return "تاریخ نباید بعد از یک سال باشد";
        return "";
      case DateUsageType.services:
        if (date.isAfter(truncatedNowUtc) &&
            !date.isAtSameMomentAs(truncatedNowUtc)) {
          return "تاریخ نمی‌تواند در آینده باشد";
        }
        return "";
    }
  }

  bool _isNumberInRange(String src, int min, int max) {
    if (src.isEmpty) return false;
    final n = int.tryParse(src);
    if (n == null) return false;
    return n >= min && n <= max;
  }
}

final dateInputProvider = ChangeNotifierProvider.autoDispose
    .family<DateInputViewModel, DateUsageType>(
      (ref, usageType) => DateInputViewModel(usageType: usageType),
    );
