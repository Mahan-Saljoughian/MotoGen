import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/core/global_error_handling/app_with_container.dart';

// Add a restart notifier
final restartNotifierProvider = StateProvider<int>((ref) => 0);

class ConnectivityWatcher extends ConsumerStatefulWidget {
  const ConnectivityWatcher({super.key});

  // Static method to manually check connectivity
  static Future<void> checkConnectivityNow() async {
    final connectivity = Connectivity();
    final result = await connectivity.checkConnectivity();
    final isDisconnected = result.every((r) => r == ConnectivityResult.none);
    if (isDisconnected) {
      AppWithContainer.writeGlobalError(
        "No network connection. Please check your Internet.",
      );
    } else {
      AppWithContainer.writeGlobalError(null);
    }
  }

  @override
  ConsumerState<ConnectivityWatcher> createState() =>
      _ConnectivityWatcherState();
}

class _ConnectivityWatcherState extends ConsumerState<ConnectivityWatcher> {
  late final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    // Delay the initial check to ensure the app is fully initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeConnectivity();
    });
  }

  void _initializeConnectivity() {
    // Cancel any existing subscription
    _subscription?.cancel();

    // === INITIAL CHECK ===
    _connectivity.checkConnectivity().then((result) {
      if (mounted) {
        final isDisconnected = result.every(
          (r) => r == ConnectivityResult.none,
        );
        if (isDisconnected) {
          AppWithContainer.writeGlobalError(
            "No network connection. Please check your Internet.",
          );
        } else {
          AppWithContainer.writeGlobalError(null);
        }
      }
    });

    // === REAL-TIME LISTENER ===
    _subscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      if (mounted) {
        final isDisconnected = results.every(
          (r) => r == ConnectivityResult.none,
        );
        if (isDisconnected) {
          AppWithContainer.writeGlobalError(
            "No network connection. Please check your Internet.",
          );
        } else {
          AppWithContainer.writeGlobalError(null);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch for restart events
    ref.listen<int>(restartNotifierProvider, (previous, next) {
      if (previous != next) {
        // Re-initialize on restart
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _initializeConnectivity();
          }
        });
      }
    });

    return const SizedBox.shrink();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
