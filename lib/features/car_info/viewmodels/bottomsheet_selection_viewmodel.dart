import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/car_info/config/picker_item.dart';


class BottomsheetSelectionViewmodel extends ChangeNotifier {
  PickerItem? _selectedItem;
  PickerItem? get selectedItem => _selectedItem;

  BottomsheetSelectionViewmodel();
  BottomsheetSelectionViewmodel.initial(PickerItem? selected)
    : _selectedItem = selected;

  void select(PickerItem item) {
    if (_selectedItem != item) {
      _selectedItem = item;
      notifyListeners();
    }
  }

  bool isSelected(PickerItem item) => _selectedItem?.id == item.id;

  void clear() {
    _selectedItem = null;
    notifyListeners();
  }
}

final bottomsheetSelectionProvider =
    ChangeNotifierProvider.autoDispose<BottomsheetSelectionViewmodel>(
      (ref) => BottomsheetSelectionViewmodel(),
    );
