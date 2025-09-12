import 'package:flutter/material.dart';
import 'package:motogen/core/services/fade_route.dart';
import 'package:motogen/features/home_screen/widget/service_navigator.dart';
import 'package:motogen/features/onboarding/views/onboarding_indicator.dart';
import 'package:motogen/features/onboarding/views/onboarding_page_2.dart';
import 'package:motogen/features/chat_screen/views/chat_screen.dart';
import 'package:motogen/features/home_screen/view/home_screen.dart';
import 'package:motogen/features/profile_screen/view/profile_screen.dart';
import 'package:motogen/features/car_services/base/view/service_screen.dart';
import 'package:motogen/main_scaffold.dart';

Route<dynamic>? appRoutes(RouteSettings settings) {
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
}
