// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../config/core.dart';
import '../../model/faq_model.dart';

class FAQCard extends StatelessWidget {
  final FAQ faq;

  const FAQCard({
    super.key,
    required this.faq,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
      margin: EdgeInsets.only(bottom: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.w),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.blue,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                      ),
                      child: const Icon(
                        Icons.question_mark_rounded,
                        color: AppColors.blue,
                        size: 18,
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Expanded(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: Text(
                          faq.question,
                          style: AppStyles.heading4.copyWith(
                            color: AppColors.blue,
                          ),
                          maxLines: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              faq.answer.isEmpty
                  ? const SizedBox()
                  : Container(
                      margin: EdgeInsets.only(bottom: 12.w),
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Text(
                        faq.answer,
                        style: AppStyles.normalText,
                        maxLines: 10,
                      ),
                    ),
              GestureDetector(
                onTap: () async {
                  if (await canLaunch(faq.videoURL)) {
                    await launch(faq.videoURL);
                  }
                },
                child: Text(
                  faq.videoURL,
                  style: AppStyles.heading4.copyWith(
                    color: AppColors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
