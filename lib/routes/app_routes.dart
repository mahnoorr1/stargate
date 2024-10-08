import 'package:flutter/material.dart';
import 'package:stargate/drawer/drawer.dart';
import 'package:stargate/drawer/screens/faq.dart';
import 'package:stargate/drawer/screens/legal_notice.dart';
import 'package:stargate/drawer/screens/privacy_policy.dart';
import 'package:stargate/drawer/screens/terms.dart';
import 'package:stargate/navbar/navbar.dart';
import 'package:stargate/screens/login/login_screen.dart';
import 'package:stargate/screens/onboarding/onboarding1.dart';
import 'package:stargate/screens/signup/signup_screen.dart';
import 'package:stargate/splash.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String navbar = '/navbar';
  static const String drawer = '/drawer';
  static const String home = '/home';
  static const String terms = '/terms';
  static const String policy = '/policy';
  static const String legalNotice = '/legalNotice';
  static const String faq = '/faq';

  static Map<String, WidgetBuilder> routes = {
    onboarding: (context) => const OnBoardingScreen1(),
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    signup: (context) => const SignUpScreen(),
    navbar: (context) => const NavBarScreen(),
    drawer: (context) => const CustomDrawer(),
    terms: (context) => const TermsScreen(),
    policy: (context) => const PrivacyPolicyScreen(),
    legalNotice: (context) => const LegalNoticeScreen(),
    faq: (context) => const FAQScreen(),
  };
}
