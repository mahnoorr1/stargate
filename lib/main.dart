import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:stargate/config/core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stargate/cubit/real_estate_listing/cubit.dart';
import 'package:stargate/cubit/service_providers/cubit.dart';
import 'package:stargate/legal_documents/providers/legal_document_provider.dart';
import 'package:stargate/routes/app_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'faqs/providers/faq_provider.dart';
import 'providers/user_info_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
          ChangeNotifierProvider(create: (_) => LegalDocumentProvider()),
          ChangeNotifierProvider(create: (_) => FaqProvider()),
        ],
        child: const MyApp(),
      );
    }),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool onboardDone = false;
  String accessToken = '';
  String route = '';
  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, child) {
        return MaterialApp(
          builder: EasyLoading.init(),
          title: 'Stargate',
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
        );
      },
    );
  }
}
