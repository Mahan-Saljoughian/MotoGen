import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/core/global_error_handling/app.dart';
import 'package:motogen/core/global_error_handling/view/update_page.dart';
import 'package:motogen/core/services/custom_exceptions.dart';

final globalErrorProvider = StateProvider<GlobalErrorState?>((ref) => null);

class GlobalErrorState {
  final String message;
  final String? updateUrl;
  final bool? isForceUpdate;

  GlobalErrorState({
    required this.message,
    this.updateUrl,
    this.isForceUpdate = false,
  });
}

class GlobalErrorHandler {
  static late WidgetRef ref;

  static void init(WidgetRef widgetRef) {
    ref = widgetRef;
  }

  static void handle(Object error) {
    final notifier = ref.read(globalErrorProvider.notifier);
    final current = notifier.state;

    // Force update wins permanently until reset
    if (error is ForceUpdateException) {
      notifier.state = GlobalErrorState(
        message: error.message,
        updateUrl: error.updateUrl,
        isForceUpdate: true,
      );
      ref.read(appLoadedProvider.notifier).state = true;
      return;
    }

    // If we already have force update, block overrides
    if (current?.isForceUpdate == true) return;

    if (error is SocketException || error is CustomGlobalError) {
      notifier.state = GlobalErrorState(
        message: 'socket_exception', // special marker
      );
      return;
    }

    notifier.state = GlobalErrorState(message: error.toString());
  }
}
