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

  String normalizePersianDigits(String input) {
    const englishDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const persianDigits = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    for (int i = 0; i < 10; i++) {
      input = input.replaceAll(persianDigits[i], englishDigits[i]);
    }
    return input;
  }

  String? phoneNumberValidator(String? input) {
    if (input == null || input.trim().isEmpty) {
      return " شماره موبایلـت رو وارد کن";
    }
    final normalized = normalizePersianDigits(input.trim());
    if (!phoneRegExp.hasMatch(normalized)) {
      return "یک شماره موبایل معتبر وارد کن!";
    }
    return null;
  }

  void _onTextChanged() {
    _error = phoneNumberValidator(phoneController.text.trim());
    _isValid = _error == null;
    
    notifyListeners();
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
}

class PhoneStorage {
  static Future<void> savePhoneNumber(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_phone_number", phone);
  }

  static Future<String?> loadPhoneNumnber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_phone_number");
  }
}

final phoneNumberControllerProvider = ChangeNotifierProvider(
  (ref) => PhoneNumberControllerViewModel(),
);
