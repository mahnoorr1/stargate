import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stargate/screens/onboarding/widgets/onboard_content.dart';

import '../../features/content_management/providers/getting_started_content_provider.dart';

class OnBoardingScreen3 extends StatefulWidget {
  const OnBoardingScreen3({super.key});

  @override
  State<OnBoardingScreen3> createState() => _OnBoardingScreen3State();
}

class _OnBoardingScreen3State extends State<OnBoardingScreen3> {
  void storeOnboardToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('onboardDone', true);
  }

  @override
  Widget build(BuildContext context) {
    final gettingStartedProvider = Provider.of<GettingStartedProvider>(context);
    final remoteOnboardData = gettingStartedProvider.gettingStartedContent;

    return Scaffold(
      appBar: OnBoardAppBar(index: 2),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        child: OnboardContent(
          image: remoteOnboardData![2].picture,
          isNetworkImage: true,
          title: onboardData[2].title,
          description: onboardData[2].description,
          index: 2,
          onNextButtonTap: () {
            storeOnboardToken();
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          },
        ),
      ),
    );
  }
}
