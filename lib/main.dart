import 'package:flutter/material.dart';
import 'package:stargate/config/core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stargate/routes/app_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, child) {
        return MaterialApp(
          builder: EasyLoading.init(),
          title: 'Stargate',
          initialRoute: AppRoutes.onboarding,
          debugShowCheckedModeBanner: false,
          routes: AppRoutes.routes,
          theme: ThemeData(
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
