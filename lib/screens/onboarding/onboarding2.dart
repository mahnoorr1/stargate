import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stargate/screens/onboarding/widgets/onboard_content.dart';

import '../../content_management/providers/getting_started_content_provider.dart';
import 'onboarding3.dart';

class OnBoardingScreen2 extends StatefulWidget {
  const OnBoardingScreen2({super.key});

  @override
  State<OnBoardingScreen2> createState() => _OnBoardingScreen2State();
}

class _OnBoardingScreen2State extends State<OnBoardingScreen2> {
  void storeOnboardToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('onboardDone', true);
  }

  @override
  Widget build(BuildContext context) {
    final gettingStartedProvider = Provider.of<GettingStartedProvider>(context);
    final remoteOnboardData = gettingStartedProvider.gettingStartedContent;

    return Scaffold(
      appBar: OnBoardAppBar(index: 1),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        child: OnboardContent(
          image: remoteOnboardData![1].picture,
          isNetworkImage: true,
          title: onboardData[1].title,
          description: onboardData[1].description,
          index: 1,
          onNextButtonTap: () {
            storeOnboardToken();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const OnBoardingScreen3()));
          },
        ),
      ),
    );
  }
}
