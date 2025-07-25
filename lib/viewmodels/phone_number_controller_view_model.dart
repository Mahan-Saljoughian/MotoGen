import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhoneNumberControllerViewModel extends ChangeNotifier {
  final phoneController = TextEditingController();

  bool _isValid = false;
  bool get isValid => _isValid;

  PhoneNumberControllerViewModel() {
    phoneController.addListener(_validatePhone);
  }

  void _validatePhone() {
    _isValid = _isIranianPhoneNumber(phoneController.text);
    notifyListeners();
  }

  bool _isIranianPhoneNumber(String input) {
    final reg = RegExp(r'^09\d{9}$');
    return reg.hasMatch(input);
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
