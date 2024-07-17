import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/screens/onboarding/widgets/onboard_content.dart';

import 'onboarding3.dart';

class OnBoardingScreen2 extends StatefulWidget {
  const OnBoardingScreen2({super.key});

  @override
  State<OnBoardingScreen2> createState() => _OnBoardingScreen2State();
}

class _OnBoardingScreen2State extends State<OnBoardingScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OnBoardAppBar(index: 1),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        child: OnboardContent(
          image: onboardData[1].imagePath,
          isNetworkImage: false,
          title: onboardData[1].title,
          description: onboardData[1].description,
          index: 1,
          onNextButtonTap: () {
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
