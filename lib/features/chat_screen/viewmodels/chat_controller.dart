import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatController extends ChangeNotifier {
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void clearText() {
    textController.clear();
    notifyListeners();
  }
}

// use ChangeNotifierProvider from Riverpod
final chatControllerProvider =
    ChangeNotifierProvider.autoDispose<ChatController>((ref) {
      final vm = ChatController();
      return vm;
    });
