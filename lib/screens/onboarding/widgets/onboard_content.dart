import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/utils/app_images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/widgets/buttons/membership_button.dart';
import 'package:stargate/screens/onboarding/widgets/next_button.dart';

import '../../../localization/localization.dart';
import '../../../localization/translation_strings.dart';
import '../../../features/membership/screens/membership_screen.dart';

class OnboardContent extends StatelessWidget {
  final String image;
  final bool isNetworkImage;
  final String title;
  final String description;
  final VoidCallback onNextButtonTap;
  final int index;
  const OnboardContent({
    super.key,
    required this.image,
    required this.isNetworkImage,
    required this.title,
    required this.description,
    required this.onNextButtonTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                isNetworkImage ? Image.network(image) : Image.asset(image),
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                        title,
                        style: AppStyles.heading1,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                      ),
                    ),
                    SizedBox(
                      height: 16.w,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        description,
                        style: AppStyles.normalText,
                        textAlign: TextAlign.center,
                        maxLines: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Padding(
                padding: EdgeInsets.only(bottom: 30.w),
                child: NextButton(onPressed: onNextButtonTap, index: index)),
          ),
        ],
      ),
    );
  }
}

class OnBoardingDataModel {
  final String imagePath;
  final String title;
  final String description;

  OnBoardingDataModel({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

List onboardData = [
  OnBoardingDataModel(
    imagePath: AppImages.onboard1,
    title: 'Offer or request a property',
    description:
        'Offer or request properties and collaborate with industry professionals',
  ),
  OnBoardingDataModel(
    imagePath: AppImages.onboard2,
    title: 'Service Providers',
    description:
        'Get Services by service providers like, notaries, lawyers, Trustees, Real Estate Appraisers, and Property Managers. Contact them and make your work easier or offer your service.',
  ),
  OnBoardingDataModel(
    imagePath: AppImages.onboard3,
    title: 'Become an Investor or find one',
    description:
        'Become an Investor and specify your interest where you want to invest, or find an investor for an off-market transaction',
  ),
];

// ignore: must_be_immutable
class OnBoardAppBar extends StatelessWidget implements PreferredSizeWidget {
  int index;
  OnBoardAppBar({
    super.key,
    required this.index,
  });
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: index != 0
          ? Platform.isIOS
              ? GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 32),
                      child: Icon(
                        Icons.arrow_forward,
                      ),
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                  ),
                )
          : const SizedBox(),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MembershipScreen(),
                ),
              );
            },
            child: Row(
              children: [
                Container(
                  height: 40.w,
                  width: 40.w,
                  margin: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.w),
                    ),
                    // ignore: deprecated_member_use
                    color: AppColors.lightBlue.withOpacity(0.5),
                  ),
                  child: Icon(
                    Icons.star,
                    color: Colors.amber[600],
                  ),
                ),
                Container(
                  height: 40.w,
                  width: 120.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.w),
                    ),
                    color: AppColors.lightBlue,
                  ),
                  child: Center(
                    child: Text(
                      AppLocalization.of(context)!
                          .translate(TranslationString.membership),
                      style: AppStyles.heading4
                          .copyWith(color: AppColors.darkBlue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
