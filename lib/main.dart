import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/features/car_info/config/car_info_config_list.dart'
    show carInfoFirstPageFields, carInfoSecondPageFields;
import 'package:motogen/features/car_info/views/car_info_screen.dart';
import 'package:motogen/features/car_info/views/car_nickname_screen.dart';
import 'package:motogen/features/chat_screen/views/chat_screen.dart';
import 'package:motogen/features/onboarding/views/onboarding_indicator.dart';
import 'package:motogen/features/onboarding/views/onboarding_page_1.dart';
import 'package:motogen/features/onboarding/views/personal_info_screen.dart';
import 'package:motogen/features/phone_number/views/enter_phone_number_screen.dart';
import 'package:motogen/features/phone_number/views/validate_code_screen.dart';

void main() {
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //showPerformanceOverlay: true,
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
        currentPage: 4,
        count: 6,
        onNext: () {},
        onBack: () {},
        carInfoField: carInfoSecondPageFields,
      ),
    );
  }
}
