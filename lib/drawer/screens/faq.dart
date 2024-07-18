import 'package:flutter/material.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/drawer/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        color: AppColors.backgroundColor,
        child: const Column(
          children: [
            Heading(heading: "Frequently Asked Questions"),
          ],
        ),
      ),
    );
  }
}
