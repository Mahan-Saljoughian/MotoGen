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
  static const int maxNickLength = 16;

  static String? nicknameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "لطفا نام مستعار خودرو را وارد کنید";
    }
    if (!nicknameRegExp.hasMatch(value)) {
      return "فقط حروف، اعداد و فاصله مجاز است";
    }
    if (value.length > maxNickLength) {
      return "حداکثر $maxNickLength کاراکتر مجاز است";
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
