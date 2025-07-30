import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shamsi_date/shamsi_date.dart';

class DateInputViewModel extends ChangeNotifier {
  String _day = '';
  String _month = '';
  String _year = '';

  bool _dayValid = false;
  bool _monthValid = false;
  bool _yearValid = false;

  String get day => _day;
  String get month => _month;
  String get year => _year;

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
    _day = value;
    _dayValid = _isNumberInRange(_day, 1, 31) && _day.isNotEmpty;
    notifyListeners();
  }

  void setMonth(String value) {
    _month = value;
    _monthValid = _isNumberInRange(_month, 1, 12) && _month.isNotEmpty;
    notifyListeners();
  }

  void setYear(String value) {
    _year = value;
    _yearValid = (value.length == 4) && value.startsWith('14');
    notifyListeners();
  }

  DateTime? get asDateTime {
    if (!_isFieldsValid) return null;
    try {
      final jalali = Jalali(
        int.parse(_year),
        int.parse(_month),
        int.parse(_day),
      );
      return jalali.toDateTime();
    } catch (_) {
      return null;
    }
  }

  bool get _isFutureDateValid {
    if (_isFieldsValid) return false;
    final inputDate = asDateTime;
    if (inputDate == null) return false;
    final now = DateTime.now();
    return inputDate.isAfter(now);
  }

  bool get dayValid => _dayValid;
  bool get monthValid => _monthValid;
  bool get yearValid => _yearValid;

  bool get _isFieldsValid => _dayValid && _monthValid && _yearValid;
  bool get isFieldsValid => _isFieldsValid;

  bool get isFutureDateValid => _isFutureDateValid;
  bool get isDateValid => _isFutureDateValid && _isFieldsValid;

  String get errorWhenFutureDate => "تاریخ معتبر انتخاب کن";

  bool _isNumberInRange(String src, int min, int max) {
    if (src.isEmpty) return false;
    final n = int.tryParse(src);
    if (n == null) return false;
    return n >= min && n <= max;
  }
}

final dateInputProvider =
    ChangeNotifierProvider.autoDispose<DateInputViewModel>(
      (ref) => DateInputViewModel(),
    );
