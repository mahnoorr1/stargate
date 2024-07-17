import 'package:flutter/material.dart';
import 'package:stargate/navbar/navbar.dart';
import 'package:stargate/screens/login/login_screen.dart';
import 'package:stargate/screens/onboarding/onboarding1.dart';
import 'package:stargate/screens/signup/signup_screen.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String navbar = '/navbar';
  static const String home = '/home';

  static Map<String, WidgetBuilder> routes = {
    onboarding: (context) => const OnBoardingScreen1(),
    login: (context) => const LoginScreen(),
    signup: (context) => const SignUpScreen(),
    navbar: (context) => const NavBarScreen(),
  };
}
