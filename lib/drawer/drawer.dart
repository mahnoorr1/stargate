// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/providers/user_info_provider.dart';
import 'package:stargate/screens/home/home_screen.dart';
import 'package:stargate/services/user_profiling.dart';
import 'package:stargate/utils/app_images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/widgets/custom_toast.dart';

import '../content_management/providers/home_content_provider.dart';

class CustomDrawer extends StatefulWidget {
  final Function(int)? onNavigate;
  const CustomDrawer({super.key, this.onNavigate});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
      GlobalKey<SliderDrawerState>();

  bool _isDrawerOpen = false;

  void _toggleDrawer() {
    if (_isDrawerOpen) {
      _sliderDrawerKey.currentState!.closeSlider();
    } else {
      _sliderDrawerKey.currentState!.openSlider();
    }
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeContentProvider =
        Provider.of<HomeContentProvider>(context, listen: false);
    return GestureDetector(
      child: SliderDrawer(
        key: _sliderDrawerKey,
        sliderOpenSize: 270,
        appBar: SliderAppBar(
          appBarColor: AppColors.darkBlue,
          appBarHeight: 100,
          drawerIcon: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            height: 40.w,
            width: 40.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.w),
              color: AppColors.lightBlue.withOpacity(0.1),
            ),
            child: Center(
              child: IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return RotationTransition(
                      turns: child.key == const ValueKey('icon1')
                          ? Tween<double>(begin: 1, end: 0.75)
                              .animate(animation)
                          : Tween<double>(begin: 0.75, end: 1)
                              .animate(animation),
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                  child: !_isDrawerOpen
                      ? Image.network(
                          homeContentProvider.homeContent!.drawerIcon)
                      : Icon(
                          Icons.close,
                          key: ValueKey(_isDrawerOpen ? 'icon1' : 'icon2'),
                          color: AppColors.white,
                          size: 24,
                        ),
                ),
                onPressed: _toggleDrawer,
              ),
            ),
          ),
          title: Image.network(
            homeContentProvider.homeContent!.appLogo,
            height: 45.w,
          ),
          trailing: Row(
            children: [
              SvgPicture.asset(
                AppIcons.notificationBell,
              ),
              SizedBox(
                width: 6.w,
              ),
              Container(
                height: 40.w,
                width: 40.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.w),
                  color: AppColors.blue,
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
            ],
          ),
        ),
        slider: _SliderView(
          onItemClick: (title) {
            _sliderDrawerKey.currentState!.closeSlider();
            setState(() {
              _isDrawerOpen = false;
            });
          },
        ),
        child: HomeScreen(onNavigate: widget.onNavigate),
      ),
    );
  }
}

class _SliderView extends StatelessWidget {
  final Function(String)? onItemClick;

  const _SliderView({this.onItemClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: <Widget>[
              const SizedBox(
                height: 200,
              ),
              ...[
                Menu(AppIcons.terms, 'Terms and Conditions', '/terms'),
                Menu(AppIcons.lock, 'Privacy Policy', '/policy'),
                Menu(AppIcons.legalNotice, 'Legal Notice', '/legalNotice'),
                Menu(AppIcons.faq, 'FAQ', '/faq'),
              ].map((menu) => _SliderMenuItem(
                  title: menu.title, iconData: menu.iconData, path: menu.path)),
            ],
          ),
          GestureDetector(
            onTap: () {
              deleteAccessToken();
              deleteUserData();
              UserProfileProvider().resetUserDetails();
              Navigator.popAndPushNamed(context, '/login');
              showToast(message: "Logged Out", context: context);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 40.w),
              child: Row(
                children: [
                  const Icon(Icons.logout, color: AppColors.blue),
                  SizedBox(
                    width: 20.w,
                  ),
                  const Text('Logout',
                      style: TextStyle(
                        color: AppColors.blue,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliderMenuItem extends StatelessWidget {
  final String title;
  final String iconData;
  final String path;

  const _SliderMenuItem(
      {required this.title, required this.iconData, required this.path});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(title,
            style: const TextStyle(
              color: AppColors.darkGrey,
            )),
        leading: SvgPicture.asset(
          iconData,
          color: AppColors.darkGrey,
        ),
        onTap: () => Navigator.pushNamed(context, path));
  }
}

class Menu {
  final String iconData;
  final String title;
  final String path;

  Menu(this.iconData, this.title, this.path);
}
