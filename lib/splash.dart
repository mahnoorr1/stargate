// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/providers/real_estate_provider.dart';
import 'package:stargate/providers/service_providers_provider.dart';
import 'package:stargate/providers/user_info_provider.dart';
import 'package:stargate/widgets/animated/entrance_fader.dart';

import 'content_management/providers/membership_content.dart';
import 'routes/app_routes.dart';
import 'utils/app_images.dart';

import 'content_management/providers/getting_started_content_provider.dart';
import 'content_management/providers/home_content_provider.dart';
import 'content_management/providers/listing_content_provider.dart';
import 'content_management/providers/offer_request_property_content_provider.dart';
import 'content_management/providers/profile_content_provider.dart';
import 'content_management/providers/search_content_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool? onboardDone;

  Future<void> _initializeProviders() async {
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
    ]);
  }

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
      _initializeProviders();
      if (onboardDone == true) {
        if (authData == null || authData == '') {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.login,
          );
        } else {
          // AllUsersCubit serviceProviders =
          //     BlocProvider.of<AllUsersCubit>(context);
          // await serviceProviders.getAllUsers();

          await UserProfileProvider.c(context).fetchUserProfile();
          print("Checking Incomplete");
          if (UserProfileProvider.c(context).incompleteProfile()) {
            Navigator.pushReplacementNamed(context, '/incompleteProfileDrawer');
          } else {
            await AllUsersProvider.c(context).fetchUsers();
            await RealEstateProvider.c(context).fetchAllListings();
            _initializeProviders();

            Navigator.pushReplacementNamed(context, '/navbar');
          }
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
