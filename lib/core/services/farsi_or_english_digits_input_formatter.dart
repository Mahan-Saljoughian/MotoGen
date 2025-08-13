import 'package:flutter/services.dart';

class FarsiOrEnglishDigitsInputFormatter extends TextInputFormatter {
  static final _englishFarsiDigitRegExp = RegExp(r'[0-9۰-۹]');
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, 
    TextEditingValue newValue,
  ) {
    final filtered = newValue.text.split('').where((c) => _englishFarsiDigitRegExp.hasMatch(c)).join();
    return TextEditingValue(
      text: filtered,
      selection: newValue.selection,
    );
  }


  static String normalizePersianDigits(String input) {
  const englishDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const persianDigits = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
  for (int i = 0; i < 10; i++) {
    input = input.replaceAll(persianDigits[i], englishDigits[i]);
  }
  return input;
}

}