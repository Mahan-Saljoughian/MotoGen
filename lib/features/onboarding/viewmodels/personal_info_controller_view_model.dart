import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    loadFromPrefs();
    /* resetSharedPref(); */
  }

  static final RegExp nameRegExp = RegExp(r'^[\u0600-\u06FFa-zA-Z\s\-]+$');

  static String? nameValidator(String? text) {
    if (text == null || text.trim().isEmpty) {
      return "الزامی!";
    }
    if (!nameRegExp.hasMatch(text.trim())) {
      return "نام معتبر وارد کنید!";
    }
    return null;
  }

  static String? lastNameValidator(String? text) {
    if (text == null || text.trim().isEmpty) {
      return "الزامی!";
    }
    if (!nameRegExp.hasMatch(text.trim())) {
      return "نام خانوادگی معتبر وارد کنید!";
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

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name') ?? '';
    final lastName = prefs.getString('last_name') ?? '';
    nameController.text = name;
    lastNameController.text = lastName;
    _onNameChanged();
    _onLastNameChanged();
  }

  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', nameController.text.trim());
    await prefs.setString('last_name', lastNameController.text.trim());
  }

  /* Future<void> resetSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('name');
    prefs.remove('last_name');
  } */

  Future<void> printSavedPersonalInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('name') ?? '(no name)';
    final savedLastName = prefs.getString('last_name') ?? '(no lastName)';
    Logger().i('saved info: $savedName $savedLastName');
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
