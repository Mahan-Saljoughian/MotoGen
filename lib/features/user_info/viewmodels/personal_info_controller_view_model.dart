import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class PersonalInfoViewModel extends ChangeNotifier {
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();

  bool _isNameValid = false;
  bool _isLastNameValid = false;

  String? _errorName;
  String? _errorLastName;

  bool get isNameValid => _isNameValid;
  bool get isLastNameValid => _isLastNameValid;

  String? get errorName => _errorName;
  String? get errorLastName => _errorLastName;

  bool get isButtonEnabled => _isNameValid && _isLastNameValid;

  PersonalInfoViewModel() {
    nameController.addListener(_onNameChanged);
    lastNameController.addListener(_onLastNameChanged);
  }
  static final RegExp nameRegExp = RegExp(
    r'''[a-zA-Z0-9\u0600-\u06FF\u200C\u200D\s\-_.,!?'"()]+$''',
  );
  static String? nameValidator(String? text) {
    if (text == null || text.trim().isEmpty) {
      return "الزامی!";
    }
    final trimmed = text.trim();
    if (trimmed.length < 2 || trimmed.length > 30) {
      return "نام باید بین 2 تا 30 کاراکتر باشد";
    }
    if (!nameRegExp.hasMatch(trimmed)) {
      return "نام شامل کاراکتر های غیر مجاز است";
    }
    return null;
  }

  static String? lastNameValidator(String? text) {
    if (text == null || text.trim().isEmpty) {
      return "الزامی!";
    }
    final trimmed = text.trim();
    if (trimmed.length < 2 || trimmed.length > 30) {
      return "نام خانوادگی باید بین 2 تا 30 کاراکتر باشد";
    }
    if (!nameRegExp.hasMatch(trimmed)) {
      return "نام خانوادگی شامل کاراکتر های غیر مجاز است";
    }
    return null;
  }

  void _onNameChanged() {
    _errorName = nameValidator(nameController.text.trim());
    _isNameValid = _errorName == null;
    notifyListeners();
  }

  void _onLastNameChanged() {
    _errorLastName = lastNameValidator(lastNameController.text.trim());
    _isLastNameValid = _errorLastName == null;
    notifyListeners();
  }


  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }
}

final personalInfoProvider = ChangeNotifierProvider(
  (ref) => PersonalInfoViewModel(),
);
