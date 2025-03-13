// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/providers/user_info_provider.dart';
import 'package:stargate/screens/profile/edit_profile_screen.dart';
import 'package:stargate/services/user_profiling.dart';
import 'package:stargate/utils/app_images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/widgets/custom_toast.dart';

import '../content_management/providers/home_content_provider.dart';
import '../localization/language_toggle_button.dart';
import '../localization/localization.dart';
import '../localization/translation_strings.dart';
import '../models/profile.dart';
import '../screens/profile/membership_screen.dart';
import '../widgets/dialog_box.dart';

class IncompleteCustomDrawer extends StatefulWidget {
  final Function(int)? onNavigate;
  const IncompleteCustomDrawer({super.key, this.onNavigate});

  @override
  State<IncompleteCustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<IncompleteCustomDrawer> {
  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
      GlobalKey<SliderDrawerState>();

  bool _isDrawerOpen = false;
  bool _isUserDataLoaded = false; // Track if the user data is loaded

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
  void initState() {
    super.initState();
    UserProfileProvider profileProvdier = UserProfileProvider.c(context);
    fetchUserProfile();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (UserProfileProvider.c(context).incompleteProfile()) {
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
      } else if (!UserProfileProvider.c(context).profileApproved()) {
        showCustomDialog(
          context: context,
          circleBackgroundColor: const Color.fromRGBO(0, 0, 0, 0),
          titleText: AppLocalization.of(context)!
              .translate(TranslationString.unapprovedProfile),
          titleColor: AppColors.black,
          descriptionText: AppLocalization.of(context)!
              .translate(TranslationString.unapprovedProfileDescription),
          buttonText:
              AppLocalization.of(context)!.translate(TranslationString.ok),
          onButtonPressed: () {
            Navigator.pop(context);
          },
        );
      }
    });
  }

  Future<void> fetchUserProfile() async {
    UserProfileProvider provider = UserProfileProvider.c(context);
    try {
      await provider.fetchUserProfile();
      setState(() {
        _isUserDataLoaded = true; // Set user data as loaded
      });
    } catch (e) {
      showToast(
        message: AppLocalization.of(context)!
            .translate(TranslationString.unableToFetchDetails),
        context: context,
        isAlert: true,
      );
      setState(() {
        _isUserDataLoaded =
            true; // Even if there's an error, stop loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProfileProvider provider = UserProfileProvider.c(context);
    final homeContentProvider =
        Provider.of<HomeContentProvider>(context, listen: false);

    // If user is not loaded, show a loading indicator
    if (!_isUserDataLoaded) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final user = User(
      services: provider.services,
      id: provider.id,
      name: provider.name,
      email: provider.email,
      image: provider.profileImage,
      properties: provider.properties,
      address: provider.address,
      city: provider.city,
      country: provider.countryName,
      references: provider.references,
      websiteLink: provider.websiteLink,
    );
    if (user.name != '') {
      setState(() {
        _isUserDataLoaded = true;
      });
    }

    return GestureDetector(
      child: SliderDrawer(
        key: _sliderDrawerKey,
        sliderOpenSize: 270,
        appBar: SliderAppBar(
          appBarHeight: 100,
          drawerIcon: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            height: 40.w,
            width: 40.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.w),
              color: AppColors.blue,
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
          title: Text(
            AppLocalization.of(context)!
                .translate(TranslationString.editProfile),
            style: AppStyles.heading3,
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
        child: EditProfile(
          user: user,
          backButton: false,
        ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: <Widget>[
              const SizedBox(
                height: 70,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const MembershipScreen()),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.h),
                      border: Border.all(
                        width: 2,
                        color: const Color.fromARGB(255, 247, 189, 42),
                      ),
                      color: Colors.amber.withOpacity(0.2),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 12.w,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.amber[600],
                        ),
                        SizedBox(
                          width: 12.w,
                        ),
                        Text(
                          AppLocalization.of(context)!
                              .translate(TranslationString.membership),
                          style: AppStyles.heading4.copyWith(
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ...[
                Menu(
                    AppIcons.terms,
                    AppLocalization.of(context)!
                        .translate(TranslationString.termsAndConditions),
                    '/terms'),
                Menu(
                    AppIcons.lock,
                    AppLocalization.of(context)!
                        .translate(TranslationString.privacyPolicy),
                    '/policy'),
                Menu(
                    AppIcons.legalNotice,
                    AppLocalization.of(context)!
                        .translate(TranslationString.legalNotice),
                    '/legalNotice'),
                Menu(
                    AppIcons.faq,
                    AppLocalization.of(context)!
                        .translate(TranslationString.faq),
                    '/faq'),
              ].map((menu) => _SliderMenuItem(
                  title: menu.title, iconData: menu.iconData, path: menu.path)),
            ],
          ),
          SizedBox(height: 40.w),
          const LanguageToggleButton(),
          GestureDetector(
            onTap: () {
              deleteAccessToken();
              deleteUserData();
              UserProfileProvider().resetUserDetails();
              Navigator.popAndPushNamed(context, '/login');
              showToast(
                  message: AppLocalization.of(context)!
                      .translate(TranslationString.loggedOut),
                  context: context);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 40.w),
              child: Row(
                children: [
                  const Icon(Icons.logout, color: AppColors.blue),
                  SizedBox(
                    width: 20.w,
                  ),
                  Text(
                      AppLocalization.of(context)!
                          .translate(TranslationString.logout),
                      style: const TextStyle(
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
