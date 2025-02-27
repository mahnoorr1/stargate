import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/content_management/providers/home_content_provider.dart';
import 'package:stargate/localization/locale_notifier.dart';
import 'package:stargate/providers/real_estate_provider.dart';
import 'package:stargate/providers/service_providers_provider.dart';
import 'package:stargate/providers/user_info_provider.dart';
import 'package:stargate/screens/home/widgets/property_card.dart';
import 'package:stargate/screens/home/widgets/service_provider_card.dart';
import 'package:stargate/screens/property_request_screen/property_request_screen.dart';
import 'package:stargate/services/helper_methods.dart';
import 'package:stargate/widgets/loader/loader.dart';
import 'package:stargate/widgets/screen/screen.dart';

import '../../localization/localization.dart';
import '../../localization/translation_strings.dart';
import '../../providers/notification_provider.dart';
import '../../utils/notifications_permission_handler.dart';
import '../../widgets/dialog_box.dart';

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
      Future.microtask(() {
        getListing();
        // ignore: use_build_context_synchronously
        NotificationPermissionHelper.requestNotificationPermission(context);
      });
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
          titleText: AppLocalization.of(context)!
              .translate(TranslationString.incompleteProfileTitle),
          titleColor: AppColors.black,
          descriptionText: AppLocalization.of(context)!
              .translate(TranslationString.incompleteProfileDescription),
          buttonText:
              AppLocalization.of(context)!.translate(TranslationString.ok),
          onButtonPressed: () {
            Navigator.pop(context);
          },
        );
      }
    });
    Provider.of<NotificationProvider>(context, listen: false)
        .fetchNotifications();
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

    return Screen(
      overlayWidgets: [
        if (realEstateProvider.loading) const FullScreenLoader(loading: true),
      ],
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: UserProfileProvider.c(context).membership ==
                "66c2ff151bf7b7176ee92708"
            ? serviceProviderUserContent(context)
            : SingleChildScrollView(
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
                              items: realEstateProvider.allProperties.length ==
                                      1
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
                          createRequestCard(),
                        ],
                      ),
                    ),
                    serviceProviderSection(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget createRequestCard() {
    final homeContentProvider =
        Provider.of<HomeContentProvider>(context, listen: false);

    final localeNotifier = Provider.of<LocaleNotifier>(context);
    final locale = localeNotifier.locale;
    final targetLang = locale.languageCode;
    final translationStrings = Future.wait([
      translateData(homeContentProvider.homeContent!.title, targetLang),
      translateData(homeContentProvider.homeContent!.subtitle, targetLang),
      translateData(homeContentProvider.homeContent!.tagline, targetLang),
    ]);
    return FutureBuilder<List<String>>(
        future: translationStrings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
              margin: EdgeInsets.only(bottom: 12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.w),
                color: Colors.white,
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return UserProfileProvider.c(context).membership !=
                  '66c2ff551bf7b7176ee9271a'
              ? Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10.w),
                    boxShadow: [AppStyles.boxShadow],
                  ),
                  child: Row(
                    children: [
                      Image.network(
                        homeContentProvider.homeContent!.picture,
                        width: targetLang == 'de'
                            ? MediaQuery.of(context).size.width * 0.2
                            : MediaQuery.of(context).size.width * 0.25,
                      ),
                      SizedBox(width: 12.w),
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.55,
                            child: Text(
                              targetLang == 'en'
                                  ? homeContentProvider.homeContent!.title
                                  : snapshot.data![0],
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
                              targetLang == 'en'
                                  ? homeContentProvider.homeContent!.subtitle
                                  : snapshot.data![1],
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
                                  targetLang == 'en'
                                      ? homeContentProvider.homeContent!.tagline
                                      : snapshot.data![2],
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
                )
              : Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10.w),
                    boxShadow: [AppStyles.boxShadow],
                  ),
                  child: Column(
                    children: [
                      Image.network(
                        homeContentProvider.homeContent!.picture,
                        height: 130.w,
                      ),
                      SizedBox(width: 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              targetLang == 'en'
                                  ? homeContentProvider.homeContent!.title
                                  : snapshot.data![0],
                              style: AppStyles.heading3.copyWith(
                                color: AppColors.darkBlue,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 8.w),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              targetLang == 'en'
                                  ? homeContentProvider.homeContent!.subtitle
                                  : snapshot.data![1],
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  targetLang == 'en'
                                      ? homeContentProvider.homeContent!.tagline
                                      : snapshot.data![2],
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
                );
        });
  }

  Widget serviceProviderSection() {
    final allUsersProvider = Provider.of<AllUsersProvider>(context);

    if (allUsersProvider.users.isEmpty) {
      return Center(
          child: Text(AppLocalization.of(context)!
              .translate(TranslationString.noServiceProvidersAvailable)));
    }

    final filteredUsers = allUsersProvider.users
        .where((user) {
          return user.services.isNotEmpty && // Check for at least one service
              user.services[0].details['name'] != 'Investor' &&
              user.services[0].details['name'] != 'Loan Broker' &&
              user.services[0].details['name'] != 'Real Estate Agent' &&
              user.address != null &&
              user.address!.isNotEmpty;
        })
        .take(3)
        .toList();
    final serviceProviderForPremiumUser =
        allUsersProvider.users.firstWhere((user) {
      return user.services.isNotEmpty &&
          user.services[0].details['name'] != 'Loan Broker' &&
          user.services[0].details['name'] != 'Real Estate Agent' &&
          user.address != null &&
          user.address!.isNotEmpty;
    });
    final serviceProviderForSpecialMember = allUsersProvider.users.firstWhere(
        (user) =>
            user.services.isNotEmpty &&
            user.image != null &&
            user.image!.isNotEmpty &&
            user.address != null &&
            user.address!.isNotEmpty,
        orElse: () => allUsersProvider.users.first);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.w),
          GestureDetector(
            onTap: () {
              widget.onNavigate!(1);
            },
            child: UserProfileProvider.c(context).membership ==
                    '66c2ff551bf7b7176ee9271a'
                ? const SizedBox()
                : Text(
                    AppLocalization.of(context)!
                        .translate(TranslationString.serviceProviders),
                    style: AppStyles.heading4.copyWith(
                      color: AppColors.blue,
                    ),
                  ),
          ),
          SizedBox(height: 8.w),
          if (allUsersProvider.users.isNotEmpty)
            UserProfileProvider.c(context).membership ==
                        "66c2ff151bf7b7176ee92708" ||
                    UserProfileProvider.c(context).membership ==
                        '66c2ff461bf7b7176ee92713'
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Column(
                      children: filteredUsers
                          .map((user) => Padding(
                                padding: EdgeInsets.only(bottom: 10.w),
                                child: ServiceProviderHomeCard(
                                  user: user,
                                ),
                              ))
                          .toList(),
                    ),
                  )
                : UserProfileProvider.c(context).membership ==
                        '66c2ff151bf7b7176ee92722'
                    ? ServiceProviderHomeCard(
                        user: serviceProviderForPremiumUser,
                      )
                    : UserProfileProvider.c(context).membership ==
                            '66c2ff241bf7b7176ee9270c'
                        ? ServiceProviderHomeCard(
                            user: serviceProviderForSpecialMember,
                          )
                        : const SizedBox(),
        ],
      ),
    );
  }

  Widget serviceProviderUserContent(BuildContext context) {
    final notificationProvider =
        Provider.of<NotificationProvider>(context, listen: true);
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: Padding(
          padding: EdgeInsets.only(
            top: 36.w,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalization.of(context)!
                          .translate(TranslationString.recentNotifications),
                      style: AppStyles.heading4.copyWith(
                        color: AppColors.blue,
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, '/notifications'),
                      child: Text(
                        AppLocalization.of(context)!
                            .translate(TranslationString.viewMore),
                        style: const TextStyle(
                            color: AppColors.darkGrey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              notificationProvider.isLoading
                  ? const Center(
                      child:
                          CircularProgressIndicator()) // Show loading spinner
                  : notificationProvider.notifications.isEmpty
                      ? Expanded(
                          child: Center(
                              child: Text(AppLocalization.of(context)!
                                  .translate(
                                      TranslationString.noNorificationsFound))))
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: ListView.builder(
                            itemCount:
                                notificationProvider.notifications.length < 2
                                    ? notificationProvider.notifications.length
                                    : 2,
                            itemBuilder: (context, index) {
                              final notification =
                                  notificationProvider.notifications[index];
                              final localeNotifier =
                                  Provider.of<LocaleNotifier>(context);
                              final locale = localeNotifier.locale;
                              final targetLang = locale.languageCode;
                              if (targetLang == 'en') {
                                return buildNotificationCard(
                                  title: notification.title,
                                  description: notification.message,
                                  imageUrl: notification.profileImage,
                                  date:
                                      "${notification.date} ${notification.time}",
                                );
                              } else {
                                final translationStrings = Future.wait([
                                  translateData(notification.title, targetLang),
                                  translateData(
                                      notification.message, targetLang),
                                ]);
                                FutureBuilder<List<String>>(
                                    future: translationStrings,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.w, vertical: 12.w),
                                          margin: EdgeInsets.only(bottom: 12.w),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.w),
                                            color: Colors.white,
                                          ),
                                          child: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }
                                      return buildNotificationCard(
                                        title: snapshot.data![0],
                                        description: snapshot.data![1],
                                        imageUrl: notification.profileImage,
                                        date:
                                            "${notification.date} ${notification.time}",
                                      );
                                    });
                              }
                            },
                          ),
                        ),
              SizedBox(
                height: 16.w,
              ),
              serviceProviderSection(),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildNotificationCard({
    required String title,
    required String description,
    required String imageUrl,
    required String date,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: imageUrl.isEmpty
                      ? const Icon(Icons.person,
                          color: AppColors.darkGrey, size: 30)
                      : ClipOval(
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.person,
                                  color: AppColors.darkGrey, size: 30);
                            },
                          ),
                        ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppStyles.heading4,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        description,
                        style: AppStyles.normalText,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                date,
                style: const TextStyle(
                  color: AppColors.darkGrey,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
