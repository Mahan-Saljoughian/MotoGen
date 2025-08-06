import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneNumberControllerViewModel extends ChangeNotifier {
  final phoneController = TextEditingController();

  bool _isValid = false;
  bool get isValid => _isValid;

  String? _error;
  String? get error => _error;

  PhoneNumberControllerViewModel() {
    phoneController.addListener(_onTextChanged);
  }

  static final RegExp phoneRegExp = RegExp(r'^09\d{9}$');

  String? phoneNumberValidator(String? input) {
    if (input == null || input.isEmpty) {
      return " شماره موبایلـت رو وارد کن";
    }
    if (!phoneRegExp.hasMatch(input)) {
      return "یک شماره موبایل معتبر وارد کن!";
    }
    return null;
  }

  void _onTextChanged() {
    final normalized = normalizePersianDigits(phoneController.text.trim());
    _error = phoneNumberValidator(normalized);
    _isValid = _error == null;

    notifyListeners();
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
}

final phoneNumberControllerProvider = ChangeNotifierProvider(
  (ref) => PhoneNumberControllerViewModel(),
);

String normalizePersianDigits(String input) {
  const englishDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const persianDigits = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
  for (int i = 0; i < 10; i++) {
    input = input.replaceAll(persianDigits[i], englishDigits[i]);
  }
  return input;
}
