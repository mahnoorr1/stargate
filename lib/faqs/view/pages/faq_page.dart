// ignore_for_file: unused_result

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stargate/faqs/view/widgets/faq_card.dart';
import 'package:stargate/localization/localization.dart';
import 'package:stargate/localization/translation_strings.dart';

import '../../../config/core.dart';
import '../../../drawer/widgets/widgets.dart';
import '../../../widgets/loader/loader.dart';
import '../../providers/faq_provider.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  @override
  void initState() {
    Provider.of<FaqProvider>(context, listen: false).getFAQs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        color: AppColors.backgroundColor,
        child: Column(
          children: [
            Heading(
                heading: AppLocalization.of(context)!
                    .translate(TranslationString.frequentlyAskedQuestions)),
            const SizedBox(height: 20),
            Consumer<FaqProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Expanded(child: Center(child: Loader()));
                } else if (provider.faqs != null) {
                  return Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: provider.faqs!.length,
                      itemBuilder: (context, index) {
                        return FAQCard(faq: provider.faqs![index]);
                      },
                    ),
                  );
                } else {
                  return const Center(child: Text("Something Went Wrong"));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
