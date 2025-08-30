import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';

String formatJalaliDate(DateTime date) {
  final localDt = date.toLocal();
  final jalali = Jalali.fromDateTime(localDt);
  return '${jalali.year}/${jalali.month.toString().padLeft(2, '0')}/${jalali.day.toString().padLeft(2, '0')}';
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

String formatNumberToPersianK(int number) {
  if (number >= 1000) {
    // Divide by 1000 and remove .0 if it’s a whole number
    final value = number / 1000;
    final noTrailingZeros = value % 1 == 0
        ? value.toInt().toString()
        : value.toStringAsFixed(1); // up to 1 decimal
    return "$noTrailingZeros هزار";
  }
  return number.toString();
}
