
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NicknameValidator extends ChangeNotifier {
  final nickNameController = TextEditingController();

  String? _error;
  bool _isNickNameValid = false;

  String? get error => _error;
  bool get isNickNameValid => _isNickNameValid;

  NicknameValidator() {
    nickNameController.addListener(_onTextChanged);
  }

  static final RegExp nicknameRegExp = RegExp(
    r'^[\u0600-\u06FFa-zA-Z0-9\u06F0-\u06F9 ]+$',
  );
  static const int minNickLength = 1;
  static const int maxNickLength = 30;

  static String? nicknameValidator(String? value) {
    // Nickname is optional, so empty is valid
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }

    final trimmed = value.trim();

    if (trimmed.length < minNickLength || trimmed.length > maxNickLength) {
      return "نام مستعار باید بین 1 تا 30 کاراکتر باشد";
    }

    // You might want to update the regex to match backend if needed
    if (!nicknameRegExp.hasMatch(trimmed)) {
      return "فقط حروف، اعداد و فاصله مجاز است";
    }

    return null;
  }

  void _onTextChanged() {
    _error = nicknameValidator(nickNameController.text.trim());
    _isNickNameValid = _error == null;
    notifyListeners();
  }

  @override
  void dispose() {
    nickNameController.dispose();
    super.dispose();
  }
}

final nickNameValidatorProvider = ChangeNotifierProvider.autoDispose(
  (ref) => NicknameValidator(),
);
