import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CodeControllerViewModel extends ChangeNotifier {
  final List<String> digits = List.filled(4, "");
  Timer? _timer;
  int _secondsLeft = 120; // 2 minutes

  int get secondsLeft => _secondsLeft;

  void startTimer() {
    _timer?.cancel();
    _secondsLeft = 120;
    notifyListeners();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        _secondsLeft--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  void resetCode() {
    for (int i = 0; i < digits.length; i++) {
      digits[i] = "";
    }
    notifyListeners();
  }

  void cancelTimer() {
    _timer?.cancel();
    notifyListeners();
  }

  void updateDigit(int index, String value) {
    digits[index] = value;
    notifyListeners();
  }

  String get code => digits.join();

  bool get isComplete => digits.every((d) => d.isNotEmpty);

  bool get isTimerActive => _secondsLeft > 0;

  String get timerText {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final codeControllerProvider = ChangeNotifierProvider(
  (ref) => CodeControllerViewModel(),
);
