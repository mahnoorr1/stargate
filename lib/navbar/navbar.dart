// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/features/content_management/providers/profile_content_provider.dart';
import 'package:stargate/drawer/drawer.dart';
import 'package:stargate/localization/localization.dart';
import 'package:stargate/localization/translation_strings.dart';
import 'package:stargate/providers/user_info_provider.dart';
import 'package:stargate/screens/listings/listings_screen.dart';
import 'package:stargate/screens/profile/profile_screen.dart';
import 'package:stargate/screens/services_screen/services_screen.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../features/content_management/providers/home_content_provider.dart';
import '../features/content_management/providers/listing_content_provider.dart';
import '../features/content_management/providers/search_content_provider.dart';

// ignore: must_be_immutable
class NavBarScreen extends StatefulWidget {
  const NavBarScreen({
    super.key,
  });

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  int selected = 0;
  bool heart = false;
  final controller = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void navigateTo(int index) {
    setState(() {
      selected = index;
      controller.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final membership = UserProfileProvider.c(context).membership;

    List<Widget> screens = [];
    if (membership == "66c2ff151bf7b7176ee92708") {
      setState(() {
        screens = [
          CustomDrawer(
            onNavigate: navigateTo,
          ),
          const ServicesScreen(),
          const ProfileScreen(),
        ];
      });
    } else if (membership == '66c2ff551bf7b7176ee9271a') {
      screens = [
        CustomDrawer(
          onNavigate: navigateTo,
        ),
        const ListingsScreen(),
        const ProfileScreen(),
      ];
    } else {
      setState(() {
        screens = [
          CustomDrawer(
            onNavigate: navigateTo,
          ),
          const ServicesScreen(),
          const ListingsScreen(),
          const ProfileScreen(),
        ];
      });
    }
    final homeContentProvider =
        Provider.of<HomeContentProvider>(context, listen: false);
    final listingContentProvider =
        Provider.of<ListingContentProvider>(context, listen: false);
    final servicesContentProvider =
        Provider.of<SearchContentProvider>(context, listen: false);
    final profileContentProvider =
        Provider.of<ProfileContentProvider>(context, listen: false);
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: StylishBottomBar(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            20.w,
          ),
          topRight: Radius.circular(
            20.w,
          ),
        ),
        option: AnimatedBarOptions(
          iconStyle: IconStyle.Default,
        ),
        items: membership == "66c2ff151bf7b7176ee92708"
            ? [
                BottomBarItem(
                  icon: Image.network(
                    homeContentProvider.homeContent!.homeIcon,
                    width: 20,
                    height: 24,
                    color: AppColors.primaryGrey,
                  ),
                  selectedIcon: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.blue,
                    ),
                    child: Center(
                      child: Image.network(
                        homeContentProvider.homeContent!.homeIcon,
                        width: 24,
                        height: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  selectedColor: AppColors.blue,
                  unSelectedColor: AppColors.primaryGrey,
                  title: Text(
                    AppLocalization.of(context)!
                        .translate(TranslationString.home),
                    style: AppStyles.heading4,
                  ),
                ),
                BottomBarItem(
                  icon: Image.network(
                    servicesContentProvider.searchContent!,
                    width: 20,
                    height: 24,
                    color: AppColors.primaryGrey,
                  ),
                  selectedIcon: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.blue,
                    ),
                    child: Center(
                      child: Image.network(
                        servicesContentProvider.searchContent!,
                        width: 24,
                        height: 24,
                        color: Colors.white, // Icon turns white
                      ),
                    ),
                  ),
                  selectedColor: AppColors.blue,
                  unSelectedColor: AppColors.primaryGrey,
                  title: Text(
                    AppLocalization.of(context)!
                        .translate(TranslationString.services),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                BottomBarItem(
                  icon: Image.network(
                    profileContentProvider.profileContent!.profileIcon,
                    width: 18,
                    height: 24,
                    color: AppColors.primaryGrey,
                  ),
                  selectedIcon: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.blue,
                    ),
                    child: Center(
                      child: Image.network(
                        profileContentProvider.profileContent!.profileIcon,
                        width: 24,
                        height: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  selectedColor: AppColors.blue,
                  unSelectedColor: AppColors.primaryGrey,
                  title: Text(
                    AppLocalization.of(context)!
                        .translate(TranslationString.profile),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ]
            : membership == '66c2ff551bf7b7176ee9271a'
                ? [
                    BottomBarItem(
                      icon: Image.network(
                        homeContentProvider.homeContent!.homeIcon,
                        width: 20,
                        height: 24,
                        color: AppColors
                            .primaryGrey, // Ensure grey for unselected state
                      ),
                      selectedIcon: Image.network(
                        homeContentProvider.homeContent!.homeIcon,
                        width: 22,
                        height: 24,
                        color: AppColors.blue,
                      ),
                      selectedColor: AppColors.blue,
                      unSelectedColor: AppColors.primaryGrey,
                      title: Text(
                        AppLocalization.of(context)!
                            .translate(TranslationString.home),
                        style: AppStyles.heading4,
                      ),
                    ),
                    BottomBarItem(
                      icon: Image.network(
                        listingContentProvider.listingContent!.icon,
                        width: 22,
                        height: 24,
                        color: AppColors.primaryGrey,
                      ),
                      selectedIcon: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.blue,
                        ),
                        child: Center(
                          child: Image.network(
                            listingContentProvider.listingContent!.icon,
                            width: 24,
                            height: 24,
                            color: Colors.white, // Icon turns white
                          ),
                        ),
                      ),
                      selectedColor: AppColors.blue,
                      unSelectedColor: AppColors.primaryGrey,
                      title: Text(
                        AppLocalization.of(context)!
                            .translate(TranslationString.listings),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    BottomBarItem(
                      icon: Image.network(
                        profileContentProvider.profileContent!.profileIcon,
                        width: 18,
                        height: 24,
                        color: AppColors.primaryGrey,
                      ),
                      selectedIcon: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.blue,
                        ),
                        child: Center(
                          child: Image.network(
                            profileContentProvider.profileContent!.profileIcon,
                            width: 24,
                            height: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      selectedColor: AppColors.blue,
                      unSelectedColor: AppColors.primaryGrey,
                      title: Text(
                        AppLocalization.of(context)!
                            .translate(TranslationString.profile),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ]
                : [
                    BottomBarItem(
                      icon: Image.network(
                        homeContentProvider.homeContent!.homeIcon,
                        width: 20,
                        height: 24,
                        color: AppColors.primaryGrey,
                      ),
                      selectedIcon: Container(
                        width: 50, // Adjust circle size
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.blue, // Blue background
                        ),
                        child: Center(
                          child: Image.network(
                            homeContentProvider.homeContent!.homeIcon,
                            width: 24,
                            height: 24,
                            color: Colors.white, // Icon turns white
                          ),
                        ),
                      ),
                      selectedColor: AppColors.blue,
                      unSelectedColor: AppColors.primaryGrey,
                      title: Text(
                        AppLocalization.of(context)!
                            .translate(TranslationString.home),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    BottomBarItem(
                      icon: Image.network(
                        servicesContentProvider.searchContent!,
                        width: 20,
                        height: 24,
                        color: AppColors.primaryGrey,
                      ),
                      selectedIcon: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.blue,
                        ),
                        child: Center(
                          child: Image.network(
                            servicesContentProvider.searchContent!,
                            width: 24,
                            height: 24,
                            color: Colors.white, // Icon turns white
                          ),
                        ),
                      ),
                      selectedColor: AppColors.blue,
                      unSelectedColor: AppColors.primaryGrey,
                      title: Text(
                        AppLocalization.of(context)!
                            .translate(TranslationString.services),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    BottomBarItem(
                      icon: Image.network(
                        listingContentProvider.listingContent!.icon,
                        width: 22,
                        height: 24,
                        color: AppColors.primaryGrey,
                      ),
                      selectedIcon: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.blue,
                        ),
                        child: Center(
                          child: Image.network(
                            listingContentProvider.listingContent!.icon,
                            width: 24,
                            height: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      selectedColor: AppColors.blue,
                      unSelectedColor: AppColors.primaryGrey,
                      title: Text(
                        AppLocalization.of(context)!
                            .translate(TranslationString.listings),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    BottomBarItem(
                      icon: Image.network(
                        profileContentProvider.profileContent!.profileIcon,
                        width: 18,
                        height: 24,
                        color: AppColors.primaryGrey,
                      ),
                      selectedIcon: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.blue,
                        ),
                        child: Center(
                          child: Image.network(
                            profileContentProvider.profileContent!.profileIcon,
                            width: 24,
                            height: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      selectedColor: AppColors.blue,
                      unSelectedColor: AppColors.primaryGrey,
                      title: Text(
                        AppLocalization.of(context)!
                            .translate(TranslationString.profile),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
        currentIndex: selected,
        notchStyle: NotchStyle.circle,
        onTap: (index) {
          if (index == selected) return;
          controller.jumpToPage(index);
          setState(() {
            selected = index;
          });
        },
      ),
      body: SafeArea(
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller,
          children: screens,
        ),
      ),
    );
  }
}
