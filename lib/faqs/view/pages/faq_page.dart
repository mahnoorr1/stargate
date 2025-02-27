// ignore_for_file: unused_result

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stargate/faqs/model/faq_model.dart';
import 'package:stargate/faqs/view/widgets/faq_card.dart';
import 'package:stargate/localization/locale_notifier.dart';
import 'package:stargate/localization/localization.dart';
import 'package:stargate/localization/translation_strings.dart';
import 'package:translator/translator.dart';

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

  Future<Map<String, String>> translateFAQ(
    String question,
    String answer,
    String targetLang,
  ) async {
    final translator = GoogleTranslator();

    // Translation results
    final results = <String, String>{};

    // Translate question if not empty
    if (question.isNotEmpty) {
      final translatedQuestion =
          await translator.translate(question, to: targetLang);
      results['question'] = translatedQuestion.text;
    } else {
      results['question'] = 'No question provided'; // Fallback text
    }

    // Translate answer if not empty
    if (answer.isNotEmpty) {
      final translatedAnswer =
          await translator.translate(answer, to: targetLang);
      results['answer'] = translatedAnswer.text;
    } else {
      results['answer'] = 'No answer provided'; // Fallback text
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    final localeNotifier = Provider.of<LocaleNotifier>(context);
    final locale = localeNotifier.locale;
    final targetLang = locale.languageCode;

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
                        if (targetLang == 'en') {
                          return FAQCard(faq: provider.faqs![index]);
                        } else {
                          return FutureBuilder(
                            future: translateFAQ(provider.faqs![index].question,
                                provider.faqs![index].answer, targetLang),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 12.w),
                                  margin: EdgeInsets.only(bottom: 12.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.w),
                                    color: Colors.white,
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              if (snapshot.hasError) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 12.w),
                                  margin: EdgeInsets.only(bottom: 12.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.w),
                                    color: Colors.white,
                                  ),
                                  child: Text(
                                    "Error: Unable to translate",
                                    style: AppStyles.heading4
                                        .copyWith(color: Colors.red),
                                  ),
                                );
                              }
                              FAQ faq = FAQ(
                                  question: snapshot.data!['question']!,
                                  answer: snapshot.data!['answer']!,
                                  videoURL: provider.faqs![index].videoURL);
                              return FAQCard(faq: faq);
                            },
                          );
                        }
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
