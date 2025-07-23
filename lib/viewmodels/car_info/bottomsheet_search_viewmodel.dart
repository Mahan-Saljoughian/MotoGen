import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomsheetSearchViewmodel extends ChangeNotifier {
  final List<String> items;
  String _query = '';

  BottomsheetSearchViewmodel({required this.items});

  String get query => _query;

  set query(String value) {
    if (_query != value) {
      _query = value;
      notifyListeners();
    }
  }

  List<String> get filteredItems {
    if (_query.isEmpty) return items;
    return items
        .where((e) => e.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }
}

final bottomsheetSearchProvider =
    ChangeNotifierProvider.autoDispose<BottomsheetSearchViewmodel>((ref) {
      throw UnimplementedError();
    });
