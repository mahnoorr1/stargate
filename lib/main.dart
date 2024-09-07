import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stargate/config/core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stargate/cubit/real_estate_listing/cubit.dart';
import 'package:stargate/cubit/service_providers/cubit.dart';
import 'package:stargate/routes/app_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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

  void checkOnBoardCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      onboardDone = prefs.getBool('onboardDone') ?? false;
      accessToken = prefs.getString('accessToken') ?? '';
    });
    setState(() {});
  }

  String initialRoute() {
    if (accessToken != '') {
      return AppRoutes.drawer;
    } else if (accessToken == '' ||
        accessToken.isEmpty && onboardDone == true) {
      return AppRoutes.login;
    } else {
      return AppRoutes.onboarding;
    }
  }

  @override
  void initState() {
    super.initState();
    checkOnBoardCheck();
    setState(() {
      route = initialRoute();
      loaded = true;
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, child) {
        return MaterialApp(
          builder: EasyLoading.init(),
          title: 'Stargate',
          initialRoute: loaded ? route : null,
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
