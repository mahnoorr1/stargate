// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/models/profile.dart';
import 'package:stargate/models/real_estate_listing.dart';
import 'package:stargate/providers/user_info_provider.dart';
import 'package:stargate/screens/property_request_screen/property_request_screen.dart';
import 'package:stargate/utils/app_data.dart';
import 'package:stargate/utils/app_images.dart';
import 'package:stargate/widgets/buttons/bubble_text_button.dart';
import 'package:stargate/widgets/buttons/custom_tab_button.dart';
import 'package:stargate/widgets/custom_toast.dart';
import 'package:stargate/widgets/loader/loader.dart';
import 'package:stargate/widgets/screen/screen.dart';
import '../../localization/localization.dart';
import '../../localization/translation_strings.dart';
import '../../services/user_profiling.dart';
import 'edit_profile_screen.dart';
import 'package:stargate/widgets/buttons/membership_button.dart';
import 'widgets/post_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool hasShownNoPropertiesToast = false;
  String selectedRequestType = 'offer';
  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    UserProfileProvider provider = UserProfileProvider.c(context);
    try {
      await provider.fetchUserProfile();
    } catch (e) {
      showToast(
        message: AppLocalization.of(context)!
            .translate(TranslationString.unableToFetchDetails),
        context: context,
        isAlert: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      overlayWidgets: [
        Consumer<UserProfileProvider>(builder: (context, provider, child) {
          if (provider.isLoading) {
            log('Loading');
            return const FullScreenLoader(loading: true);
          }

          if (provider.properties.isEmpty &&
              !hasShownNoPropertiesToast &&
              !provider.isLoading) {
            hasShownNoPropertiesToast = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // showToast(
              //   message: "No properties found",
              //   context: context,
              //   isAlert: true,
              //   color: Colors.redAccent,
              // );
            });
          }

          return const SizedBox();
        })
      ],
      child: Consumer<UserProfileProvider>(builder: (context, provider, child) {
        return buildContent(provider);
      }),
    );
  }

  Widget buildContent(UserProfileProvider provider) {
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

    List<RealEstateListing> userProperties = selectedRequestType == 'offer'
        ? user.properties!.where((p) => p.requestType == 'offering').toList()
        : user.properties!.where((p) => p.requestType == 'requesting').toList();
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30.w),
                        bottomRight: Radius.circular(30.w),
                      ),
                      child: user.image != null && user.image != ''
                          ? Image(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.45,
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                user.image!,
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.45,
                              color: AppColors.lightGrey,
                              child: Image.asset(AppImages.user),
                            ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.32,
                        left: MediaQuery.of(context).size.width * 0.025,
                        right: MediaQuery.of(context).size.width * 0.025,
                      ),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.11,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24.w, vertical: 12.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50.w),
                                ),
                                color: AppColors.lightBlue.withOpacity(0.5),
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.56,
                                          child: Text(
                                            user.name,
                                            style: AppStyles.heading3.copyWith(
                                              color: AppColors.white,
                                            ),
                                            maxLines: 2,
                                          ),
                                        ),
                                        Text(
                                          user.email,
                                          style:
                                              AppStyles.supportiveText.copyWith(
                                            color: AppColors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          child: Text(
                                            AppLocalization.of(context)!
                                                .translate(
                                                    TranslationString.posts),
                                            style: AppStyles.heading4.copyWith(
                                              color: AppColors.white,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          user.properties?.length.toString() ??
                                              '0',
                                          style: AppStyles.heading4
                                              .copyWith(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.47,
                        left: MediaQuery.of(context).size.width * 0.025,
                        right: MediaQuery.of(context).size.width * 0.025,
                      ),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalization.of(context)!
                                    .translate(TranslationString.myPosts),
                                style: AppStyles.heading4,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          PropertyRequestForm()));
                                },
                                child: Text(
                                  AppLocalization.of(context)!.translate(
                                      TranslationString.createNewPost),
                                  style: AppStyles.heading4.copyWith(
                                    color: AppColors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12.w,
                          ),
                          Row(
                            children: offerRequestMapping.map((or) {
                              final localizedLabel = AppLocalization.of(context)
                                      ?.translate(or['label']!) ??
                                  or['label']!;

                              return CustomTabButton(
                                type: localizedLabel,
                                current: AppLocalization.of(context)?.translate(
                                        offerRequestMapping.firstWhere((u) =>
                                            u['type'] ==
                                            selectedRequestType)['label']!) ??
                                    offerRequestMapping.firstWhere((u) =>
                                        u['type'] ==
                                        selectedRequestType)['label']!,
                                selected: (value) {
                                  final selected =
                                      offerRequestMapping.firstWhere(
                                    (u) =>
                                        AppLocalization.of(context)
                                            ?.translate(u['label']!) ==
                                        value,
                                  );
                                  setState(() {
                                    selectedRequestType = selected['type']!;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          userProperties == null || userProperties.isEmpty
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  child: Center(
                                    child: Text(
                                      AppLocalization.of(context)!.translate(
                                          TranslationString.noProperties),
                                      style: AppStyles.supportiveText,
                                    ),
                                  ),
                                )
                              : SingleChildScrollView(
                                  child: StaggeredGrid.count(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 8.w,
                                    mainAxisSpacing: 8.w,
                                    children: List.generate(
                                      userProperties.length,
                                      (index) {
                                        return PostCard(
                                          listing: userProperties[index],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                          SizedBox(
                            height: 80.w,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.w),
              ],
            ),
          ),
          Positioned(
            top: 16.w,
            right: 12.w,
            child: InkWell(
              onTap: () async {
                final result =
                    await Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) => EditProfile(user: user),
                  ),
                );
                if (result == 'success') {
                  fetchUserProfile();
                }
              },
              child: Container(
                height: 40.w,
                width: 40.w,
                margin: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.w),
                  ),
                  color: AppColors.lightBlue.withOpacity(0.5),
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            top: 66.w,
            right: 12.w,
            child: const MembershipButton(
              textColor: AppColors.white,
            ),
          ),
          Positioned(
            bottom: 10.w,
            right: 20.w,
            child: GestureDetector(
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
              child: Container(
                width: MediaQuery.of(context).size.width * 0.45,
                height: 40.w,
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20.w,
                    ),
                    const Icon(Icons.logout, color: AppColors.white),
                    SizedBox(
                      width: 16.w,
                    ),
                    Text(
                      AppLocalization.of(context)!.translate(
                        TranslationString.logout,
                      ),
                      style: AppStyles.heading3.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    hasShownNoPropertiesToast = false;
    super.dispose();
  }
}
