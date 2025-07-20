import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalInfoViewModel extends ChangeNotifier {
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();

  bool _isNameValid = false;
  bool _isLastNameValid = false;

  bool get isNameValid => _isNameValid;
  bool get isLastNameValid => _isLastNameValid;

  bool get isButtonEnabled => _isNameValid && _isLastNameValid;

  PersonalInfoViewModel() {
    nameController.addListener(() {
      validateName(nameController.text);
    });
    lastNameController.addListener(() {
      validateLastName(lastNameController.text);
    });
    loadPersonalInfo();
    /* resetSharedPref(); */
  }

  bool _nameValidator(String value) {
    final regExp = RegExp(r'^[\u0600-\u06FFa-zA-Z\s\-]+$');
    return regExp.hasMatch(value.trim()) && value.trim().isNotEmpty;
  }

  void validateName(String value) {
    _isNameValid = _nameValidator(value);
    notifyListeners();
  }

  void validateLastName(String value) {
    _isLastNameValid = _nameValidator(value);
    notifyListeners();
  }

  Future<void> loadPersonalInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name') ?? '';
    final lastName = prefs.getString('last_name') ?? '';
    nameController.text = name;
    lastNameController.text = lastName;
    validateName(name);
    validateLastName(lastName);
  }

  Future<void> savePersonalInfo() async {
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
    print('saved info: $savedName $savedLastName');
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
