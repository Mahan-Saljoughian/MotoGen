import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhoneNumberControllerViewModel extends ChangeNotifier {
  final phoneController = TextEditingController();

  bool _isValid = false;
  bool get isValid => _isValid;

  String? _error;
  String? get error => _error;

  PhoneNumberControllerViewModel() {
    phoneController.addListener(_onTextChanged);
  }

  static final RegExp nicknameRegExp = RegExp(r'^09\d{9}$');

  static String? phoneNumberValidator(String? input) {
    if (input == null || input.trim().isEmpty) {
      return " شماره موبایلـت رو وارد کن";
    }
    if (!nicknameRegExp.hasMatch(input)) {
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

final phoneNumberControllerProvider = ChangeNotifierProvider(
  (ref) => PhoneNumberControllerViewModel(),
);
