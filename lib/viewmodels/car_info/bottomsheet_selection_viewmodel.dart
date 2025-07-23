import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomsheetSelectionViewmodel extends ChangeNotifier {
  String? _selectedItem;
  String? get selectedItem => _selectedItem;

  BottomsheetSelectionViewmodel();
  BottomsheetSelectionViewmodel.initial(String? selected)
    : _selectedItem = selected;

  void select(String item) {
    if (_selectedItem != item) {
      _selectedItem = item;
      notifyListeners();
    }
  }

  bool isSelected(String item) => _selectedItem == item;

  void clear() {
    _selectedItem = null;
    notifyListeners();
  }
}

final bottomsheetSelectionProvider =
    ChangeNotifierProvider.autoDispose<BottomsheetSelectionViewmodel>(
      (ref) => BottomsheetSelectionViewmodel(),
    );
