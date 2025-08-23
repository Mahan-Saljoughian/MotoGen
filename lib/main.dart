import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/services/fade_route.dart';

import 'package:motogen/features/car_info/viewmodels/car_use_case_api.dart';
import 'package:motogen/features/car_info/viewmodels/car_state_notifier.dart';
import 'package:motogen/features/car_services/base/view/service_screen.dart';
import 'package:motogen/features/chat_screen/views/chat_screen.dart';

import 'package:motogen/features/home_screen/view/home_screen.dart';
import 'package:motogen/features/home_screen/widget/service_navigator.dart';
import 'package:motogen/features/onboarding/views/onboarding_indicator.dart';
import 'package:motogen/features/onboarding/views/onboarding_page_2.dart';
import 'package:motogen/features/profile_screen/view/profile_screen.dart';

import 'package:motogen/features/user_info/viewmodels/user_use_case_api.dart';
import 'package:motogen/main_scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // effectively “no color”
      statusBarIconBrightness: Brightness.dark, // or .light
    ),
  );

  runApp(
    ProviderScope(
      child: ScreenUtilInit(
        designSize: Size(412, 917),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) => MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // helper
  TextTheme noLetterSpacing(TextTheme base) {
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

  var logger = Logger();
  bool _isLoggedIn = false;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    Future.microtask(_initApp);
  }

  Future<void> _initApp() async {
    final storage = const FlutterSecureStorage();
    final accessToken = await storage.read(key: 'accessToken');

    if (accessToken == null || accessToken.isEmpty) {
      _isLoggedIn = false;
      logger.i("debug No access token, go to login");
    } else {
      _isLoggedIn = true;
      try {
        await ref.getUserProfile();
        await ref.read(carStateNotifierProvider.notifier).fetchAllCars();
        // await ref.read(chatNotifierProvider.notifier).loadInitialSession();
        logger.i("debug Fetched cars at startup with saved token");
      } catch (e) {
        logger.e("debug Car fetch failed: $e");
        _isLoggedIn = false;
        await storage.delete(key: 'accessToken');
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }
    final theme = ThemeData(
      fontFamily: "IRANSansXFaNum",
      scaffoldBackgroundColor: AppColors.white100,
    );

    return MaterialApp(
      theme: theme.copyWith(textTheme: noLetterSpacing(theme.textTheme)),
      locale: const Locale('fa'),
      supportedLocales: const [Locale('fa')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/onboardingIndicator':
            return FadeRoute(page: const OnboardingIndicator());
          case '/mainApp':
            return FadeRoute(page: const MainScaffold());
          case '/home':
            return FadeRoute(page: const HomeScreen());
          case '/chat':
            return FadeRoute(page: const ChatScreen());
          case '/profile':
            return FadeRoute(page: const ProfileScreen());
          case '/refuel':
            return FadeRoute(
              page: const ServiceScreen(serviceTitle: ServiceTitle.refuel),
            );
          case '/onboardingPage2':
            return FadeRoute(page: const OnboardingPage2());
          case '/oil':
            return FadeRoute(
              page: const ServiceScreen(serviceTitle: ServiceTitle.oil),
            );
          case '/purchases':
            return FadeRoute(
              page: const ServiceScreen(serviceTitle: ServiceTitle.purchases),
            );
          case '/repair':
            return FadeRoute(
              page: const ServiceScreen(serviceTitle: ServiceTitle.repair),
            );
          default:
            return null;
        }
      },
      title: 'MotoGen',
      home: _isLoggedIn ? MainScaffold() : OnboardingIndicator(),
    );
  }
}
