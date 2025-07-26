import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CodeControllerViewModel extends ChangeNotifier {
  final List<String> digits = List.filled(4, "");

  void updateDigit(int index, String value) {
    digits[index] = value;
    notifyListeners();
  }

  String get code => digits.join();

  bool get isComplete => digits.every((d) => d.isNotEmpty);

  bool get isValid => code == "1234";
}

final codeControllerProvider = ChangeNotifierProvider(
  (ref) => CodeControllerViewModel(),
);
