// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/models/real_estate_listing.dart';
import 'package:stargate/screens/listings/listing_details_screen.dart';
import 'package:stargate/utils/app_images.dart';

class ListingCard extends StatelessWidget {
  final RealEstateListing listing;
  const ListingCard({
    super.key,
    required this.listing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context, rootNavigator: false).push(
        MaterialPageRoute(
          builder: (context) => ListingDetailsScreen(listing: listing),
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
              listing.pictures.first,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AddressMorphismRectangle(
              country: listing.country,
              state: listing.state ?? '',
              city: listing.city ?? '',
            ),
          ],
        ),
      ),
    );
  }
}

class AddressMorphismRectangle extends StatelessWidget {
  final String country;
  final String city;
  final String state;

  const AddressMorphismRectangle({
    super.key,
    required this.state,
    required this.city,
    required this.country,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 30.w,
                          height: 30.w,
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.w),
                            color: Colors.white,
                          ),
                          child: SvgPicture.asset(
                            AppIcons.location,
                            color: AppColors.blue,
                          ),
                        ),
                        SizedBox(
                          width: 6.w,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.29,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              city.isNotEmpty
                                  ? Text(
                                      city,
                                      style: AppStyles.heading4.copyWith(
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : Text(
                                      state,
                                      style: AppStyles.heading4.copyWith(
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                              SizedBox(
                                height: 2.w,
                              ),
                              Text(
                                country,
                                style: AppStyles.normalText.copyWith(
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
