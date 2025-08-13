import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsStorage {
  // ----------------- save methods ------------------------
  static Future<void> saveFirstName(String firstName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', firstName);
  }

  static Future<void> saveLastName(String lastName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastName', lastName);
  }

  static Future<void> savePhoneNumber(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phoneNumber', phoneNumber);
  }

  static Future<void> saveIsProfileCompleted(bool isProfileCompleted) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isProfileCompleted', isProfileCompleted);
  }

  static Future<void> saveUserInfo({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    bool? isProfileCompleted,
  }) async {
    if (firstName != null) await saveFirstName(firstName);
    if (lastName != null) await saveLastName(lastName);
    if (phoneNumber != null) await savePhoneNumber(phoneNumber);
    if (isProfileCompleted != null) await saveIsProfileCompleted(isProfileCompleted);
  }
  // ----------------- load methods ------------------------

  static Future<String?> loadFirstName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('firstName');
  }

  static Future<String?> loadLastName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastName');
  }

  static Future<String?> loadPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('phoneNumber');
  }

  static Future<bool?> loadIsProfileCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isProfileCompleted');
  }

  static Future<Map<String, dynamic>> loadUserInfo() async {
    return {
      'firstName': await loadFirstName(),
      'lastName': await loadLastName(),
      'phoneNumber': await loadPhoneNumber(),
      'isProfileCompleted': await loadIsProfileCompleted() ?? false,
    };
  }

  // ----------------- clear methods ------------------------
  static Future<void> clearFirstName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('firstName');
  }

  static Future<void> clearLastName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('lastName');
  }

  static Future<void> clearPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('phoneNumber');
  }

  static Future<void> clearIsProfileCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isProfileCompleted');
  }

  static Future<void> clearUserInfo() async {
    await clearFirstName();
    await clearLastName();
    await clearPhoneNumber();
    await clearIsProfileCompleted();
  }
}
