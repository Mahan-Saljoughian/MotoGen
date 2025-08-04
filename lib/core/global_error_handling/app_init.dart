import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/core/global_error_handling/connectivity_watcher.dart';

import 'package:motogen/core/global_error_handling/global_error_provider.dart';
import 'package:motogen/core/global_error_handling/global_error_screen.dart';
import 'package:motogen/core/global_error_handling/test_crash.dart';

class AppInit extends ConsumerStatefulWidget {
  const AppInit({super.key});

  @override
  ConsumerState<AppInit> createState() => _AppInitState();
}

// Add a provider to track if initial connectivity check is complete
final connectivityCheckCompleteProvider = StateProvider<bool>((ref) => false);

class _AppInitState extends ConsumerState<AppInit> {
  @override
  void initState() {
    super.initState();

    // Check connectivity on init
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ConnectivityWatcher.checkConnectivityNow();
      if (mounted) {
        ref.read(connectivityCheckCompleteProvider.notifier).state = true;
      }
    });

    FlutterError.onError = (details) {
      FlutterError.dumpErrorToConsole(details);
      Future.microtask(() {
        ref.read(globalErrorProvider.notifier).state = details.exceptionAsString();
      });
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      Future.microtask(() {
        ref.read(globalErrorProvider.notifier).state = error.toString();
      });
      return true;
    };
  }

  @override
  Widget build(BuildContext context) {
    final error = ref.watch(globalErrorProvider);
    final isCheckComplete = ref.watch(connectivityCheckCompleteProvider);

    return MaterialApp(
      theme: ThemeData(
        fontFamily: "IRANSansXFaNum",
        scaffoldBackgroundColor: Colors.white,
      ),
      locale: const Locale('fa'),
      supportedLocales: const [Locale('fa')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: 'MotoGen',
      home: Stack(
        children: [
          // Show loading until connectivity check is complete
          if (!isCheckComplete)
            const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (error != null)
            GlobalErrorScreen(error: error)
          else
            const TestCrash(),
          // ConnectivityWatcher always runs
          const ConnectivityWatcher(),
        ],
      ),
    );
  }
}