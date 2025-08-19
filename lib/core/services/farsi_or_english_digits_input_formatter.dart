import 'package:flutter/services.dart';

class FarsiOrEnglishDigitsInputFormatter extends TextInputFormatter {
  final bool allowDecimal;
  FarsiOrEnglishDigitsInputFormatter({this.allowDecimal = false});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final allowedChars = RegExp(r'[0-9۰-۹]');
    final newText = newValue.text
        .split('')
        .where((ch) => allowedChars.hasMatch(ch))
        .join();
    return TextEditingValue(text: newText, selection: newValue.selection);
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
