import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';

String formatJalaliDate(DateTime date) {
  final j = Jalali.fromDateTime(date);
  return '${j.year}/${j.month.toString().padLeft(2, '0')}/${j.day.toString().padLeft(2, '0')}';
}

String formatTomanCost(double cost) {
  final formatter = NumberFormat("#,###", "en_US");
  return "${formatter.format(cost)} تومان";
}

String formatLiter(double liter) {
  if (liter % 1 == 0) {
    return "${liter.toInt().toString()} لیتر";
  } else {
    return "${liter.toString()} لیتر";
  }
}
