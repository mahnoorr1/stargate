import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/models/membership.dart';
import 'package:stargate/widgets/buttons/custom_button.dart';
import 'package:stargate/widgets/translationWidget.dart';

import '../../localization/localization.dart';
import '../../localization/translation_strings.dart';

class MembershipCard extends StatelessWidget {
  final Membership membership;
  final String activeMembership;
  const MembershipCard({
    super.key,
    required this.membership,
    required this.activeMembership,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 8.w,
      ),
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  activeMembership == membership.tag
                      ? Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 4.w,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.w),
                            color: Colors.green,
                          ),
                          child: Text(
                            AppLocalization.of(context)!
                                .translate(TranslationString.active),
                            style: AppStyles.heading4.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
              translationWidget(
                membership.tag ?? '',
                context,
                membership.tag ?? '',
                AppStyles.heading3.copyWith(
                  color: AppColors.darkBlue,
                ),
              ),
              SizedBox(
                width: 32.w,
              ),
            ],
          ),
          SizedBox(
            height: 8.w,
          ),
          const Divider(
            color: AppColors.lightGrey,
          ),
          SizedBox(
            height: 6.w,
          ),
          ...membership.points!.map(
            (item) => Container(
              padding: EdgeInsets.only(bottom: 6.w),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: AppColors.blue,
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: translationWidget(
                      item,
                      context,
                      item,
                      AppStyles.normalText,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 12.w,
          ),
          CustomButton(
            text: activeMembership == membership.tag
                ? AppLocalization.of(context)!
                    .translate(TranslationString.subscribed)
                : AppLocalization.of(context)!
                    .translate(TranslationString.subscribe),
            color: activeMembership == membership.tag
                ? AppColors.blue
                : AppColors.primaryGrey,
          ),
        ],
      ),
    );
  }
}
