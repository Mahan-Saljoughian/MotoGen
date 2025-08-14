import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';

String formatJalaliDate(DateTime date) {
  final j = Jalali.fromDateTime(date);
  return '${j.year}/${j.month.toString().padLeft(2, '0')}/${j.day.toString().padLeft(2, '0')}';
}

String formatTomanCost(double cost) {
  final formatter = NumberFormat("#,###", "en_US");
  return formatter.format(cost);
}

String formatDecimal(double decimal) {
  if (decimal % 1 == 0) {
    return decimal.toInt().toString();
  } else {
    return decimal.toString();
  }
}
