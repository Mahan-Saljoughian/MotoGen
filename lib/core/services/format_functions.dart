import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';

String formatJalaliDate(DateTime date) {
  final j = Jalali.fromDateTime(date);
  return '${j.year}/${j.month.toString().padLeft(2, '0')}/${j.day.toString().padLeft(2, '0')}';
}

String formatNumberByThreeDigit(int number) {
  final formatter = NumberFormat("#,###", "en_US");
  return formatter.format(number);
}

String formatPersianError(Object e) {
  final raw = e.toString();
  final match = RegExp(r'([\u0600-\u06FF].*)').firstMatch(raw);
  return match != null ? match.group(1)?.trim() ?? '' : raw;
}
