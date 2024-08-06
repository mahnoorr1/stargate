import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/models/membership.dart';
import 'package:stargate/utils/app_data.dart';
import 'package:stargate/widgets/buttons/custom_button.dart';

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
          Row(
            mainAxisAlignment: activeMembership == membership.tag
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: [
              activeMembership == membership.tag
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 0.27,
                    )
                  : const SizedBox(),
              Text(
                membership.tag,
                style: AppStyles.heading3.copyWith(
                  color: AppColors.darkBlue,
                ),
              ),
              SizedBox(
                width: 32.w,
              ),
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
                        "Active",
                        style: AppStyles.heading4.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    )
                  : const SizedBox(),
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
          ...membership.points.map(
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
                    child: Text(
                      item,
                      style: AppStyles.normalText,
                      maxLines: 2,
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
            text:
                activeMembership == membership.tag ? "Subscribed" : "Subscribe",
            color: activeMembership == membership.tag
                ? AppColors.blue
                : AppColors.primaryGrey,
          ),
        ],
      ),
    );
  }
}
