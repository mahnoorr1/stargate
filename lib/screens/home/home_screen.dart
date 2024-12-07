import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/content_management/providers/home_content_provider.dart';
import 'package:stargate/providers/real_estate_provider.dart';
import 'package:stargate/providers/service_providers_provider.dart';
import 'package:stargate/providers/user_info_provider.dart';
import 'package:stargate/screens/home/widgets/property_card.dart';
import 'package:stargate/screens/home/widgets/service_provider_card.dart';
import 'package:stargate/screens/property_request_screen/property_request_screen.dart';
import 'package:stargate/widgets/loader/loader.dart';
import 'package:stargate/widgets/screen/screen.dart';

import '../../routes/app_routes.dart';
import '../../utils/notifications_permission_handler.dart';
import '../../widgets/dialog_box.dart';
import '../notification/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onNavigate;
  const HomeScreen({super.key, this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getListing();
      NotificationPermissionHelper.requestNotificationPermission(context);
    });
    UserProfileProvider profileProvdier = UserProfileProvider.c(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!profileProvdier.firstProfileInfoAlertDone &&
          (profileProvdier.address.isEmpty ||
              profileProvdier.countryName.isEmpty ||
              profileProvdier.profileImage == null ||
              profileProvdier.profileImage == '')) {
        profileProvdier.setFirstTimeAlert();
        showCustomDialog(
          context: context,
          circleBackgroundColor: const Color.fromRGBO(0, 0, 0, 0),
          titleText: "Incomplete Profile",
          titleColor: AppColors.black,
          descriptionText:
              "Your Profile Information is incomplete please go to profile section and edit your information",
          buttonText: "OK",
          onButtonPressed: () {
            Navigator.pop(context);
          },
        );
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getListing();
  }

  void getListing() async {
    RealEstateProvider realEstateProvider = RealEstateProvider.c(context);
    if (realEstateProvider.allProperties.isEmpty) {
      await realEstateProvider.fetchAllListings();
      getUsers();
    }
  }

  void getUsers() async {
    await AllUsersProvider.c(context).fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    final realEstateProvider = Provider.of<RealEstateProvider>(context);
    final allUsersProvider = Provider.of<AllUsersProvider>(context);
    final homeContentProvider =
        Provider.of<HomeContentProvider>(context, listen: false);

    return Screen(
      overlayWidgets: [
        if (realEstateProvider.loading) const FullScreenLoader(loading: true),
      ],
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    color: AppColors.darkBlue,
                  ),
                  if (realEstateProvider.allProperties.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 60.w),
                      height: 240.w,
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 240.h,
                          autoPlay: false,
                          enlargeCenterPage: false,
                          viewportFraction:
                              realEstateProvider.allProperties.length == 1
                                  ? 1
                                  : 0.5,
                          enableInfiniteScroll: false,
                          padEnds: false,
                        ),
                        items: realEstateProvider.allProperties.length == 1
                            ? realEstateProvider.allProperties
                                .map((property) =>
                                    PropertyCardHome(property: property))
                                .toList()
                            : realEstateProvider.allProperties
                                .take(3)
                                .map((property) =>
                                    PropertyCardHome(property: property))
                                .toList(),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 150.w,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.w),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10.w),
                        boxShadow: [AppStyles.boxShadow],
                      ),
                      child: Row(
                        children: [
                          Image.network(
                            homeContentProvider.homeContent!.picture,
                            width: MediaQuery.of(context).size.width * 0.25,
                          ),
                          SizedBox(width: 12.w),
                          Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.55,
                                child: Text(
                                  homeContentProvider.homeContent!.title,
                                  style: AppStyles.heading3.copyWith(
                                    color: AppColors.darkBlue,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: 8.w),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: Text(
                                  homeContentProvider.homeContent!.subtitle,
                                  style: AppStyles.supportiveText,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: 8.w),
                              GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.of(context,
                                          rootNavigator: false)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PropertyRequestForm(),
                                    ),
                                  );
                                  if (result == 'success') {
                                    getListing();
                                  }
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      homeContentProvider.homeContent!.tagline,
                                      style: AppStyles.heading4
                                          .copyWith(color: AppColors.darkBlue),
                                    ),
                                    SizedBox(width: 8.w),
                                    const Icon(
                                      Icons.arrow_forward,
                                      color: AppColors.darkBlue,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.w),
                    GestureDetector(
                      onTap: () {
                        widget.onNavigate!(1);
                      },
                      child: Text(
                        "Service Providers",
                        style: AppStyles.heading4.copyWith(
                          color: AppColors.blue,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.w),
                    if (allUsersProvider.users.isNotEmpty)
                      ServiceProviderHomeCard(
                        user: allUsersProvider.users.firstWhere(
                          (user) =>
                              user.image != null &&
                              user.image!.isNotEmpty &&
                              user.address != null &&
                              user.address!.isNotEmpty,
                          orElse: () => allUsersProvider.users.first,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
