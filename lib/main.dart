import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:motogen/core/constants/app_colors.dart';

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
  //await HiveStorage.init();
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
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "IRANSansXFaNum",
        scaffoldBackgroundColor: AppColors.white100,
      ),
      locale: const Locale('fa'),
      supportedLocales: const [Locale('fa')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      routes: {
        '/onboardingIndicator': (context) => const OnboardingIndicator(),
        '/mainApp': (context) => const MainScaffold(),
        '/home': (context) => const HomeScreen(),
        '/chat': (context) => const ChatScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/refuel': (context) =>
            const ServiceScreen(serviceTitle: ServiceTitle.refuel),
        '/onboardingPage2': (context) => const OnboardingPage2(),
        '/oil': (context) =>
            const ServiceScreen(serviceTitle: ServiceTitle.oil),
        '/purchases': (context) =>
            const ServiceScreen(serviceTitle: ServiceTitle.purchases),
        '/repair': (context) =>
            const ServiceScreen(serviceTitle: ServiceTitle.repair),
      },
      title: 'MotoGen',
      home: _isLoggedIn ? MainScaffold() : OnboardingIndicator(),
    );
  }
}
