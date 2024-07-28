// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/models/user.dart';
import 'package:stargate/screens/services_screen/service_provider_details.dart';
import 'package:stargate/widgets/blurred_rectangle.dart';

class ListingCard extends StatelessWidget {
  final User user;
  const ListingCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context, rootNavigator: false).push(
        MaterialPageRoute(
          builder: (context) => ServiceProviderDetails(user: user),
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.47,
        height: 220,
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(30.w),
          ),
          color: Colors.grey[100],
          image: DecorationImage(
            image: NetworkImage(
              user.image,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: user.verified
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.end,
          children: [
            user.verified
                ? SizedBox(
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 40.w,
                        width: 40.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.w),
                          ),
                          color: AppColors.black.withOpacity(0.2),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            BlurredRectangle(
              title: user.name,
              subtitle:
                  "${user.getHighestExperience().toString()} years Experience",
            ),
          ],
        ),
      ),
    );
  }
}
