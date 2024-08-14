import 'package:flutter/material.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/drawer/widgets/faq_card.dart';
import 'package:stargate/drawer/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/utils/app_data.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        color: AppColors.backgroundColor,
        child: Column(
          children: [
            const Heading(heading: "Frequently Asked \nQuestions"),
            SizedBox(
              height: 18.w,
            ),
            ...faqs.map(
              (faq) => FAQCard(
                faq: faq,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
