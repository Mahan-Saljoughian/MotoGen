import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/storage/hive_storage.dart';
import 'package:motogen/features/car_info/config/car_info_config_list.dart';
import 'package:motogen/features/car_info/views/car_info_screen.dart';
import 'package:motogen/features/car_info/views/car_nickname_screen.dart';
import 'package:motogen/features/onboarding/views/onboarding_indicator.dart';
import 'package:motogen/features/onboarding/views/onboarding_page_1.dart';
import 'package:motogen/features/phone_number/views/code_confirm_screen.dart';

import 'package:motogen/main_scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveStorage.init();
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
      title: 'MotoGen',
      home: CarInfoScreen(
        currentPage: 1,
        count: 5,
        onBack: () {},
        onNext: () {},
        carInfoField: carInfoSecondPageFields,
      ) /* CarNicknameScreen(
        currentPage: 5,
        count: 5,
        onNext: () {},
        onBack: () {},
      ), */ /* CodeConfirmScreen(
        count: 5,
        currentPage: 2,
        onNext: () {},
        onBack: () {},
      ), */,
    );
  }
}
