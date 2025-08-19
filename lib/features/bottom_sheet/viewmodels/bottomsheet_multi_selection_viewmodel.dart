import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/bottom_sheet/config/picker_item.dart';

class BottomsheetMultiSelectionViewmodel extends ChangeNotifier {
  final List<PickerItem> _selectedItems;
  List<PickerItem> get selectedItems => List.unmodifiable(_selectedItems);

  BottomsheetMultiSelectionViewmodel() : _selectedItems = [];

  BottomsheetMultiSelectionViewmodel.initial(List<PickerItem> initial)
    : _selectedItems = List.from(initial);

  bool isSelected(PickerItem item) =>
      _selectedItems.any((sel) => sel.id == item.id);

  void toggle(PickerItem item) {
    final existingIndex = _selectedItems.indexWhere((sel) => sel.id == item.id);

    if (existingIndex != -1) {
      _selectedItems.removeAt(existingIndex);
    } else {
      _selectedItems.add(item);
    }
    notifyListeners();
  }

  void clear() {
    _selectedItems.clear();
    notifyListeners();
  }
}

final bottomsheetMultiSelectionProvider =
    ChangeNotifierProvider.autoDispose<BottomsheetMultiSelectionViewmodel>(
      (ref) => BottomsheetMultiSelectionViewmodel(),
    );
