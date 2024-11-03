import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/models/real_estate_listing.dart';
import 'package:stargate/screens/listings/widgets/listing_card.dart';
import 'package:stargate/widgets/blurred_rectangle.dart';

// ignore: must_be_immutable
class PropertyCardHome extends StatelessWidget {
  RealEstateListing property;
  PropertyCardHome({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220.w,
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      width: MediaQuery.of(context).size.height * 0.35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.w),
        color: AppColors.white,
      ),
      padding: EdgeInsets.all(12.w),
      child: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.w),
              child: Image.network(
                fit: BoxFit.cover,
                property.pictures[0],
              ),
            ),
          ),
          Positioned(
            right: 12.w,
            top: 12.w,
            child: BlurredRectangle(
              title: "€${property.price.toString()}",
            ),
          ),
          Positioned(
            child: AddressMorphismRectangle(
              country: property.address,
              state: property.state ?? '',
              city: property.city ?? '',
            ),
          )
        ],
      ),
    );
  }
}
