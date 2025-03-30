import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:stargate/drawer/drawer.dart';
import 'package:stargate/drawer/incompleteProfileDrawer.dart';

import 'package:stargate/features/faqs/view/pages/faq_page.dart';

import 'package:stargate/features/legal_documents/view/pages/legal_notice.dart';
import 'package:stargate/features/legal_documents/view/pages/privacy_policy.dart';
import 'package:stargate/features/legal_documents/view/pages/terms_and_conditions.dart';
import 'package:stargate/navbar/navbar.dart';
import 'package:stargate/screens/login/login_screen.dart';
import 'package:stargate/screens/onboarding/onboarding1.dart';
import 'package:stargate/screens/signup/signup_screen.dart';
import 'package:stargate/splash.dart';

import '../screens/notification/notification_screen.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String navbar = '/navbar';
  static const String drawer = '/drawer';
  static const String drawerForIncomplete = '/incompleteProfileDrawer';
  static const String home = '/home';
  static const String terms = '/terms';
  static const String policy = '/policy';
  static const String legalNotice = '/legalNotice';
  static const String faq = '/faq';
  static const String notification = '/notifications';

  static Map<String, WidgetBuilder> routes = {
    onboarding: (context) => const OnBoardingScreen1(),
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    signup: (context) => const SignUpScreen(),
    navbar: (context) => const NavBarScreen(),
    drawer: (context) => const CustomDrawer(),
    drawerForIncomplete: (context) => const IncompleteCustomDrawer(),
    terms: (context) => const TermsAndConditionsScreen(),
    policy: (context) => const PrivacyPolicyScreen(),
    legalNotice: (context) => const LegalNoticeScreen(),
    faq: (context) => const FAQScreen(),
    notification: (context) => const NotificationScreen(),
  };
}
