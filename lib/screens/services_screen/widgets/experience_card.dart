import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/utils/app_images.dart';

class ExperienceCard extends StatelessWidget {
  final String title;
  final String? subTitle;
  final int? noOfYears;
  const ExperienceCard(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.noOfYears});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 70.w,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.w),
      margin: EdgeInsets.only(bottom: 6.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.w),
        color: AppColors.lightBlue,
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            AppIcons.medal,
          ),
          SizedBox(
            width: 16.w,
          ),
          subTitle != ''
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppStyles.heading4.copyWith(
                        color: AppColors.blue,
                      ),
                    ),
                    SizedBox(
                      height: 4.w,
                    ),
                    Text(
                      subTitle!,
                      style: AppStyles.supportiveText,
                    ),
                  ],
                )
              : Text(
                  title,
                  style: AppStyles.heading4.copyWith(
                    color: AppColors.blue,
                  ),
                ),
          SizedBox(
            width: 16.w,
          ),
          const Spacer(),
          title != 'Investor'
              ? Align(
                  alignment: subTitle != null
                      ? Alignment.topLeft
                      : Alignment.centerLeft,
                  child: Text(
                    "$noOfYears years",
                    style: AppStyles.heading4.copyWith(
                      color: AppColors.blue,
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
