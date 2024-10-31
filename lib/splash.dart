// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/cubit/real_estate_listing/cubit.dart';
import 'package:stargate/cubit/service_providers/cubit.dart';
import 'package:stargate/navbar/navbar.dart';
import 'package:stargate/providers/service_providers_provider.dart';
import 'package:stargate/providers/user_info_provider.dart';
import 'package:stargate/widgets/animated/entrance_fader.dart';

import 'routes/app_routes.dart';
import 'utils/app_images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool? onboardDone;
  void next() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {});
    UserProfileProvider().getUserDetails();
    String? authData;
    setState(() {
      onboardDone = prefs.getBool('onboardDone') ?? false;
    });
    String? token = prefs.getString('accessToken') ?? '';
    setState(() {
      authData = token;
    });

    Future.delayed(const Duration(seconds: 2), () async {
      if (onboardDone == true) {
        if (authData == null || authData == '') {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.login,
          );
        } else {
          RealEstateListingsCubit listingCubit =
              BlocProvider.of<RealEstateListingsCubit>(context);
          UserProfileProvider.c(context).getUserDetails();
          await listingCubit.getAllRealEstateListings();
          // AllUsersCubit serviceProviders =
          //     BlocProvider.of<AllUsersCubit>(context);
          // await serviceProviders.getAllUsers();
          await AllUsersProvider.c(context).fetchUsers();

          Navigator.pushReplacementNamed(context, '/navbar');
        }
      } else {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.onboarding,
        );
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      next();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: EntranceFader(
          offset: const Offset(0, 100),
          duration: const Duration(seconds: 2),
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: AppColors.darkBlue,
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Image.asset(
                AppImages.logo,
                height: 50.w,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
