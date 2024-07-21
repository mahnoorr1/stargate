import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/widgets/blurred_rectangle.dart';

class ListingCard extends StatelessWidget {
  final String imageURl;
  final String title;
  final String subtitle;
  final bool isVerified;
  const ListingCard({
    super.key,
    required this.imageURl,
    required this.title,
    required this.subtitle,
    required this.isVerified,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            imageURl,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment:
            isVerified ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
        children: [
          isVerified
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
            title: title,
            subtitle: subtitle,
          ),
        ],
      ),
    );
  }
}
