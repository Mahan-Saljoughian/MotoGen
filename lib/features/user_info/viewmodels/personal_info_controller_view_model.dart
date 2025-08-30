import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalInfoViewModel extends ChangeNotifier {
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();

  final draftNameController = TextEditingController();
  final draftLastNameController = TextEditingController();

  bool _isNameValid = false;
  bool _isLastNameValid = false;
  bool _isDraftNameValid = false;
  bool _isDraftLastNameValid = false;

  String? _errorName;
  String? _errorLastName;
  String? _errorDraftName;
  String? _errorDraftLastName;

  bool get isButtonEnabled => _isNameValid && _isLastNameValid;

  bool get isDraftButtonEnabled => _isDraftNameValid && _isDraftLastNameValid;

  bool get isNameValid => _isNameValid;
  bool get isLastNameValid => _isLastNameValid;
  bool get isDraftNameValid => _isDraftNameValid;
  bool get isDraftLastNameValid => _isDraftLastNameValid;

  String? get errorName => _errorName;
  String? get errorLastName => _errorLastName;
  String? get errorDraftName => _errorDraftName;
  String? get errorDraftLastName => _errorDraftLastName;

  PersonalInfoViewModel() {
    nameController.addListener(_onNameChanged);
    lastNameController.addListener(_onLastNameChanged);

    draftNameController.addListener(_onDraftNameChanged);
    draftLastNameController.addListener(_onDraftLastNameChanged);
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

  void _onDraftNameChanged() {
    _validateDraftName();
    notifyListeners();
  }

  void _onDraftLastNameChanged() {
    _validateDraftLastName();
    notifyListeners();
  }

  void setDraftFromMain() {
    draftNameController.removeListener(_onDraftNameChanged);
    draftLastNameController.removeListener(_onDraftLastNameChanged);

    draftNameController.text = nameController.text;
    draftLastNameController.text = lastNameController.text;

    _validateDraftName();
    _validateDraftLastName();

    // Re-attach listeners
    draftNameController.addListener(_onDraftNameChanged);
    draftLastNameController.addListener(_onDraftLastNameChanged);

    notifyListeners();
  }

  void _validateDraftName() {
    final text = draftNameController.text.trim();
    _errorDraftName = nameValidator(text);
    _isDraftNameValid = _errorDraftName == null;
  }

  void _validateDraftLastName() {
    final text = draftLastNameController.text.trim();
    _errorDraftLastName = lastNameValidator(text);
    _isDraftLastNameValid = _errorDraftLastName == null;
  }

  void applyDraftToMain() {
    if (nameController.text.trim() != draftNameController.text.trim()) {
      nameController.text = draftNameController.text;
    }
    if (lastNameController.text.trim() != draftLastNameController.text.trim()) {
      lastNameController.text = draftLastNameController.text;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    draftNameController.dispose();
    draftLastNameController.dispose();
    super.dispose();
  }
}

final personalInfoProvider = ChangeNotifierProvider(
  (ref) => PersonalInfoViewModel(),
);
