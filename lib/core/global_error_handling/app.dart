import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:motogen/core/global_error_handling/view/banned_page.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/global_error_handling/viewmodel/global_error_provider.dart';
import 'package:motogen/core/global_error_handling/view/global_error_screen.dart';
import 'package:motogen/core/services/routes.dart';
import 'package:motogen/core/services/api_service.dart';
import 'package:motogen/core/services/custom_exceptions.dart';
import 'package:motogen/core/services/logger.dart';
import 'package:motogen/core/global_error_handling/view/update_page.dart';
import 'package:motogen/features/car_info/viewmodels/car_state_notifier.dart';
import 'package:motogen/features/car_info/viewmodels/car_use_case_api.dart';
import 'package:motogen/features/onboarding/views/onboarding_indicator.dart';
import 'package:motogen/features/onboarding/views/onboarding_internet.dart';
import 'package:motogen/features/user_info/viewmodels/user_use_case_api.dart';
import 'package:motogen/main_scaffold.dart';
import 'package:motogen/widgets/loading_animation.dart';

final ApiService _api = ApiService();

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppInitState();
}

final appLoadedProvider = StateProvider<bool>((ref) => false);
final startScreenProvider = StateProvider<Widget>(
  (ref) => const OnboardingIndicator(),
);

class _AppInitState extends ConsumerState<App> {
  bool _isLoggedIn = false;
  Widget _startPage = const OnboardingIndicator();

  @override
  void initState() {
    super.initState();

    GlobalErrorHandler.init(ref);

    /// --- Global Flutter error hooks ---
    FlutterError.onError = (details) {
      FlutterError.dumpErrorToConsole(details);
      Future.microtask(() {
        GlobalErrorHandler.handle(details.exception);
      });
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      Future.microtask(() {
        GlobalErrorHandler.handle(error);
      });
      return true;
    };

    // Safety timeout
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted && !ref.read(appLoadedProvider)) {
        appLogger.w(
          "Loading exceeded 30s, going to global error screen as fallback.",
        );
        ref.read(startScreenProvider.notifier).state =
            const OnboardingInternet();
        ref.read(appLoadedProvider.notifier).state = true;
      }
    });

    // Bootstrapping API flow
    Future.microtask(_initApp);
  }

  Future<void> _initApp() async {
    final storage = const FlutterSecureStorage();
    final accessToken = await storage.read(key: 'accessToken');

    if (accessToken == null || accessToken.isEmpty) {
      _isLoggedIn = false;
      _startPage = const OnboardingIndicator();
      appLogger.e("No token found, go to login.");
      if (mounted) {
        ref.read(startScreenProvider.notifier).state = _startPage;
        ref.read(appLoadedProvider.notifier).state = true;
      }
    } else {
      _isLoggedIn = true;
      try {
        final initData = await _initApi();
        final user = initData['user'];

        if (user['active'] != true) {
          _startPage = const BannedPage();
          appLogger.e("User inactive: banned.");
        } else if (user['isProfileCompleted'] == true) {
          await ref.getUserProfile();
          await ref.read(carStateNotifierProvider.notifier).fetchAllCars();
          _startPage = const MainScaffold();
        } else {
          _startPage = const OnboardingIndicator(skipPhoneStep: true);
        }
        if (mounted) {
          ref.read(startScreenProvider.notifier).state = _startPage;
          ref.read(appLoadedProvider.notifier).state = true;
        }
      } catch (e) {
        if (e is ForceUpdateException) {
          GlobalErrorHandler.handle(e);
          return;
        }

        if (ref.read(globalErrorProvider)?.isForceUpdate == true) {
          return;
        }
        final errorText = e.toString();
        appLogger.e("Init API failed: $e");
        _isLoggedIn = false;
        // await storage.delete(key: 'accessToken');
        _startPage = GlobalErrorScreen(error: errorText);
        GlobalErrorHandler.handle(e);
        if (mounted) {
          ref.read(startScreenProvider.notifier).state = _startPage;
          ref.read(appLoadedProvider.notifier).state = true;
        }
      }
    }
  }

  Future<Map<String, dynamic>> _initApi() async {
    final response = await _api.get("init");
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to get init.');
    }
    return response['data'];
  }

  TextTheme _noLetterSpacing(TextTheme base) {
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(letterSpacing: 0),
      displayMedium: base.displayMedium?.copyWith(letterSpacing: 0),
      displaySmall: base.displaySmall?.copyWith(letterSpacing: 0),
      headlineLarge: base.headlineLarge?.copyWith(letterSpacing: 0),
      headlineMedium: base.headlineMedium?.copyWith(letterSpacing: 0),
      headlineSmall: base.headlineSmall?.copyWith(letterSpacing: 0),
      titleLarge: base.titleLarge?.copyWith(letterSpacing: 0),
      titleMedium: base.titleMedium?.copyWith(letterSpacing: 0),
      titleSmall: base.titleSmall?.copyWith(letterSpacing: 0),
      bodyLarge: base.bodyLarge?.copyWith(letterSpacing: 0),
      bodyMedium: base.bodyMedium?.copyWith(letterSpacing: 0),
      bodySmall: base.bodySmall?.copyWith(letterSpacing: 0),
      labelLarge: base.labelLarge?.copyWith(letterSpacing: 0),
      labelMedium: base.labelMedium?.copyWith(letterSpacing: 0),
      labelSmall: base.labelSmall?.copyWith(letterSpacing: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final error = ref.watch(globalErrorProvider);

    final isAppLoaded = ref.watch(appLoadedProvider);
    final startScreen = ref.watch(startScreenProvider);

    final theme = ThemeData(
      fontFamily: "IRANSansXFaNum",
      scaffoldBackgroundColor: AppColors.white100,
    );

    return MaterialApp(
      theme: theme.copyWith(textTheme: _noLetterSpacing(theme.textTheme)),
      locale: const Locale('fa'),
      supportedLocales: const [Locale('fa')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRoutes,
      title: 'MotoGen',
      home: Stack(
        children: [
          if (!isAppLoaded)
            const Scaffold(body: Center(child: LoadingAnimation()))
          else if (error != null)
            GlobalErrorScreen(
              error: error.message,
              isForceUpdate: error.isForceUpdate ?? false,
              updateUrl: error.updateUrl ?? "",
            )
          else
            startScreen,
        ],
      ),
    );
  }
}
