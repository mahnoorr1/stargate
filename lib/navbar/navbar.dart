// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/drawer/drawer.dart';
import 'package:stargate/screens/listings/listings_screen.dart';
import 'package:stargate/screens/profile/profile_screen.dart';
import 'package:stargate/screens/services_screen/services_screen.dart';
import 'package:stargate/utils/app_images.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  List<Widget> screens = [];

  @override
  void initState() {
    super.initState();
    screens = [
      CustomDrawer(
        onNavigate: navigateTo,
      ),
      const ServicesScreen(),
      const ListingsScreen(),
      const ProfileScreen(),
    ];
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
        items: [
          BottomBarItem(
            icon: SvgPicture.asset(
              AppIcons.home,
              width: 20,
              color: AppColors.primaryGrey,
            ),
            selectedIcon: SvgPicture.asset(
              AppIcons.home,
              width: 22,
              color: AppColors.blue,
            ),
            selectedColor: AppColors.blue,
            unSelectedColor: AppColors.primaryGrey,
            title: const Text(
              'Home',
              style: TextStyle(fontSize: 12),
            ),
          ),
          BottomBarItem(
            icon: SvgPicture.asset(
              AppIcons.services,
              width: 20,
            ),
            selectedIcon: SvgPicture.asset(
              AppIcons.services,
              width: 22,
              color: AppColors.blue,
            ),
            selectedColor: AppColors.blue,
            unSelectedColor: AppColors.primaryGrey,
            title: const Text(
              'Services',
              style: TextStyle(fontSize: 12),
            ),
          ),
          BottomBarItem(
              icon: SvgPicture.asset(
                AppIcons.listing,
                width: 22,
              ),
              selectedIcon: SvgPicture.asset(
                AppIcons.listing,
                color: AppColors.blue,
                width: 24,
              ),
              selectedColor: AppColors.blue,
              unSelectedColor: AppColors.primaryGrey,
              title: const Text(
                'Listings',
                style: TextStyle(fontSize: 12),
              )),
          BottomBarItem(
              icon: SvgPicture.asset(
                AppIcons.profile,
                width: 18,
              ),
              selectedIcon: SvgPicture.asset(
                AppIcons.profile,
                color: AppColors.blue,
                width: 20,
              ),
              selectedColor: AppColors.blue,
              unSelectedColor: AppColors.primaryGrey,
              title: const Text(
                'Profile',
                style: TextStyle(fontSize: 12),
              )),
        ],
        currentIndex: selected,
        notchStyle: NotchStyle.square,
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
