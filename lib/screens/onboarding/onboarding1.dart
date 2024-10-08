import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stargate/screens/onboarding/widgets/onboard_content.dart';

import 'onboarding2.dart';

class OnBoardingScreen1 extends StatefulWidget {
  const OnBoardingScreen1({super.key});

  @override
  State<OnBoardingScreen1> createState() => _OnBoardingScreen1State();
}

class _OnBoardingScreen1State extends State<OnBoardingScreen1> {
  void storeOnboardToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('onboardDone', true);
  }

  @override
  Widget build(BuildContext context) {
    storeOnboardToken();
    return Scaffold(
      appBar: OnBoardAppBar(index: 0),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        child: OnboardContent(
          image: onboardData[0].imagePath,
          isNetworkImage: false,
          title: onboardData[0].title,
          description: onboardData[0].description,
          index: 0,
          onNextButtonTap: () {
            storeOnboardToken();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const OnBoardingScreen2()));
          },
        ),
      ),
    );
  }
}
