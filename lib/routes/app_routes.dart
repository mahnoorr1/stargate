import 'package:flutter/material.dart';
import 'package:stargate/screens/onboarding/onboarding.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String login = '/login';

  static Map<String, WidgetBuilder> routes = {
    onboarding: (context) => const OnBoardingScreen(),
  };
}
