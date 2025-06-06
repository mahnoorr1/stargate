// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stargate/config/core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stargate/features/content_management/providers/membership_content.dart';
import 'package:stargate/cubit/real_estate_listing/cubit.dart';
import 'package:stargate/cubit/service_providers/cubit.dart';
import 'package:stargate/firebase_options.dart';
import 'package:stargate/features/legal_documents/providers/legal_document_provider.dart';
import 'package:stargate/localization/locale_notifier.dart';
import 'package:stargate/localization/localization.dart';
import 'package:stargate/providers/real_estate_provider.dart';
import 'package:stargate/providers/service_providers_provider.dart';
import 'package:stargate/routes/app_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'features/content_management/providers/getting_started_content_provider.dart';
import 'features/content_management/providers/home_content_provider.dart';
import 'features/content_management/providers/listing_content_provider.dart';
import 'features/content_management/providers/offer_request_property_content_provider.dart';
import 'features/content_management/providers/profile_content_provider.dart';
import 'features/content_management/providers/search_content_provider.dart';
import 'features/faqs/providers/faq_provider.dart';
import 'features/membership/providers/membership_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/user_info_provider.dart';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // If Application is in background or terminated
  FirebaseMessaging.onMessageOpenedApp.listen(
    (RemoteMessage message) async {
      // ignore: avoid_print
      print("Notification opened: ${message.notification?.title}");
      if (message.data.isNotEmpty) {
        navigatorKey.currentState!.pushNamed(
          '/push-page',
          arguments: {"message": json.encode(message.data)},
        );
      }
    },
  );

  // If Application is Closed
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      print("App launched via notification: ${message.notification?.title}");
      if (message.data.isNotEmpty) {
        navigatorKey.currentState!.pushNamed(
          '/notifications',
          arguments: {"message": json.encode(message.data)},
        );
      }
    }
  });

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      print("App launched via notification: ${message.notification?.title}");
      if (message.data.isNotEmpty) {
        navigatorKey.currentState!.pushNamed(
          '/notifications',
          arguments: {"message": json.encode(message.data)},
        );
      }
    }
  });

  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  runApp(
    Builder(builder: (context) {
      return MultiProvider(
        providers: [
          BlocProvider<AllUsersCubit>(
            create: (context) => AllUsersCubit(),
          ),
          BlocProvider(
            create: (context) => RealEstateListingsCubit(),
          ),
          ChangeNotifierProvider(create: (_) => UserProfileProvider()),
          ChangeNotifierProvider(create: (_) => AllUsersProvider()),
          ChangeNotifierProvider(create: (_) => LegalDocumentProvider()),
          ChangeNotifierProvider(create: (_) => FaqProvider()),
          ChangeNotifierProvider(create: (_) => GettingStartedProvider()),
          ChangeNotifierProvider(
              create: (_) => OfferRequestPropertyContentProvider()),
          ChangeNotifierProvider(create: (_) => HomeContentProvider()),
          ChangeNotifierProvider(create: (_) => ListingContentProvider()),
          ChangeNotifierProvider(create: (_) => SearchContentProvider()),
          ChangeNotifierProvider(create: (_) => ProfileContentProvider()),
          ChangeNotifierProvider(create: (_) => RealEstateProvider()),
          ChangeNotifierProvider(create: (_) => MembershipContentProvider()),
          ChangeNotifierProvider(create: (_) => MembershipProvider()),
          ChangeNotifierProvider(create: (_) => NotificationProvider()),
          ChangeNotifierProvider(create: (_) => LocaleNotifier()),
        ],
        child: MyApp(initialMessage: initialMessage),
      );
    }),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.initialMessage});
  final RemoteMessage? initialMessage;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool onboardDone = false;
  String accessToken = '';
  String route = '';
  bool loaded = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeProviders();
    });

    // Handle when app is opened from a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data.isNotEmpty) {
        navigatorKey.currentState!.pushNamed(
          '/notifications',
          arguments: {"message": json.encode(message.data)},
        );
      }
    });
  }

  Future<void> _initializeProviders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserProfileProvider.c(context)
        .setMembership(prefs.getString('membership') ?? '');
    final gettingStartedProvider =
        Provider.of<GettingStartedProvider>(context, listen: false);
    final offerRequestProvider =
        Provider.of<OfferRequestPropertyContentProvider>(context,
            listen: false);
    final homeContentProvider =
        Provider.of<HomeContentProvider>(context, listen: false);
    final listingContentProvider =
        Provider.of<ListingContentProvider>(context, listen: false);
    final searchContentProvider =
        Provider.of<SearchContentProvider>(context, listen: false);
    final profileContentProvider =
        Provider.of<ProfileContentProvider>(context, listen: false);
    final membershipContentProvider =
        Provider.of<MembershipContentProvider>(context, listen: false);
    await Future.wait([
      gettingStartedProvider.fetchGettingStartedContent(),
      offerRequestProvider.fetchOfferRequestPropertyContent(),
      homeContentProvider.fetchHomeContent(),
      listingContentProvider.fetchListingContent(),
      searchContentProvider.fetchSearchContent(),
      profileContentProvider.fetchProfileContent(),
      membershipContentProvider.fetchMembershipContent(),
      AllUsersProvider.c(context).fetchUsers(),
      RealEstateProvider.c(context).fetchAllListings(),
      UserProfileProvider.c(context).fetchUserProfile(),
    ]);
    Future.delayed(const Duration(seconds: 3));

    setState(() {
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeNotifier = Provider.of<LocaleNotifier>(context);
    final locale = localeNotifier.locale;
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, child) {
        return MaterialApp(
          builder: EasyLoading.init(),
          title: 'Stargate',
          navigatorKey: navigatorKey,
          initialRoute: AppRoutes.splash,
          debugShowCheckedModeBanner: false,
          routes: AppRoutes.routes,
          theme: ThemeData(
            primaryColor: AppColors.blue,
            appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                titleTextStyle: AppStyles.screenTitle),
            textTheme: GoogleFonts.montserratTextTheme(),
            scaffoldBackgroundColor: Colors.white,
          ),
          // Localization
          locale: locale,
          // List of supported locales (languages)
          supportedLocales: const [
            Locale('en'), // English
            Locale('es'), // Spanish
            Locale('de'), // German
          ],

          // Localization delegates to support Material, Cupertino, and custom translations
          localizationsDelegates: const [
            AppLocalizationDelegate(), // Custom delegate for translations
            GlobalMaterialLocalizations.delegate, // Material widgets
            GlobalWidgetsLocalizations.delegate, // Basic widgets
            GlobalCupertinoLocalizations.delegate, // Cupertino widgets
          ],
          // Dynamically set the locale based on user's system preference
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first; // Default to English if no match
          },
        );
      },
    );
  }
}
