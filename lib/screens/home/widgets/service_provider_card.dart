import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/localization/localization.dart';
import 'package:stargate/models/user.dart';
import 'package:stargate/utils/app_images.dart';
import 'package:stargate/utils/app_data.dart';

// ignore: must_be_immutable
class ServiceProviderHomeCard extends StatefulWidget {
  User user;
  ServiceProviderHomeCard({super.key, required this.user});

  @override
  State<ServiceProviderHomeCard> createState() =>
      _ServiceProviderHomeCardState();
}

class _ServiceProviderHomeCardState extends State<ServiceProviderHomeCard> {
  @override
  Widget build(BuildContext context) {
    String localizedService = userMappingSimple.firstWhere(
        (u) => u['type'] == widget.user.services[0].details['name'],
        orElse: () =>
            {'label': widget.user.services[0].details['name']})['label']!;

    return Container(
      decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            AppStyles.boxShadow,
          ],
          borderRadius: BorderRadius.circular(10.w)),
      height: 150.w,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            widget.user.image != ''
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.w),
                    child: Container(
                      height: 140.w,
                      width: MediaQuery.of(context).size.width * 0.3,
                      color: AppColors.lightGrey,
                      child: Image.network(
                        widget.user.image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(
                    height: 140.w,
                    width: MediaQuery.of(context).size.width * 0.3,
                    color: AppColors.lightGrey,
                    child: Image.asset(
                      AppImages.user,
                      fit: BoxFit.cover,
                    ),
                  ),
            SizedBox(
              width: 16.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.name,
                  style: AppStyles.heading3,
                ),
                SizedBox(
                  height: 8.w,
                ),
                Text(
                  AppLocalization.of(context)!.translate(localizedService),
                  style: AppStyles.heading4.copyWith(
                    color: AppColors.blue,
                  ),
                ),
                SizedBox(
                  height: 8.w,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      AppIcons.location,
                      // ignore: deprecated_member_use
                      color: AppColors.blue,
                    ),
                    SizedBox(
                      width: 6.w,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.47,
                      child: Text(
                        widget.user.address ??
                            widget.user.city ??
                            widget.user.country ??
                            '',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
