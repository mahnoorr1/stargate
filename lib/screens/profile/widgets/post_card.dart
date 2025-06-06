// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:ui';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/providers/real_estate_provider.dart';
import 'package:stargate/providers/user_info_provider.dart';
import 'package:stargate/screens/property_request_screen/property_request_screen.dart';
import 'package:stargate/utils/app_images.dart';
import 'package:stargate/models/real_estate_listing.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/screens/listings/listing_details_screen.dart';
import 'package:stargate/widgets/custom_toast.dart';

import '../../../localization/localization.dart';
import '../../../localization/translation_strings.dart';

class PostCard extends StatefulWidget {
  final RealEstateListing listing;
  const PostCard({
    super.key,
    required this.listing,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  Future<void> deleteListing() async {
    try {
      await UserProfileProvider.c(context)
          .deleteUserProperty(widget.listing.id!);
      RealEstateProvider.c(context)
          .deletePropertyInProvider(widget.listing.id!);
      await RealEstateProvider.c(context).fetchAllListings();

      if (!mounted) return;

      showToast(
          message: AppLocalization.of(context)!
              .translate(TranslationString.deletionSuccessfull),
          context: context);
    } catch (e) {
      if (!mounted) return;

      showToast(
        message: AppLocalization.of(context)!
            .translate(TranslationString.unableToDeleteProperty),
        context: context,
        isAlert: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context, rootNavigator: false).push(
        MaterialPageRoute(
          builder: (context) => ListingDetailsScreen(listing: widget.listing),
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.47,
        height: 260,
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(30.w),
          ),
          color: Colors.grey[100],
          image: DecorationImage(
            image: NetworkImage(
              widget.listing.pictures.first,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: 30,
                    margin: EdgeInsets.only(top: 4.w),
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: widget.listing.status == 'pending'
                          ? Colors.orange[500]
                          : widget.listing.status == 'rejected'
                              ? Colors.redAccent
                              : AppColors.blue,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        AppLocalization.of(context)!
                            .translate(widget.listing.status),
                        style:
                            AppStyles.heading4.copyWith(color: AppColors.white),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PropertyRequestForm(
                              isEditingEnabled: true,
                              listing: widget.listing,
                            ),
                          ),
                        );
                      },
                      child: bubble(
                        Icons.edit,
                        Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDeleteConfirmationDialog(
                          context,
                          widget.listing.title,
                          deleteListing,
                        );
                      },
                      child: bubble(
                        Icons.delete_outline_outlined,
                        Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            AddressMorphismRectangle(
              country: widget.listing.country,
              state: widget.listing.state ?? '',
              city: widget.listing.city ?? '',
            ),
          ],
        ),
      ),
    );
  }

  Widget bubble(IconData icon, Color color) {
    return Container(
      height: 40.w,
      width: 40.w,
      margin: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20.w),
        ),
        color: AppColors.lightBlue.withOpacity(0.5),
      ),
      child: Icon(
        icon,
        color: color,
      ),
    );
  }

  void showDeleteConfirmationDialog(
      BuildContext context, String propertyName, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalization.of(context)!
              .translate(TranslationString.confirmDeletion)),
          content: Text(
            '${AppLocalization.of(context)!.translate(TranslationString.areYouSureToDeleteProperty)}"$propertyName"?',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalization.of(context)!
                  .translate(TranslationString.cancel)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              child: Text(
                  AppLocalization.of(context)!
                      .translate(TranslationString.delete),
                  style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

class AddressMorphismRectangle extends StatelessWidget {
  final String country;
  final String? city;
  final String? state;

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
                              city != null && city! != ''
                                  ? Text(
                                      city!,
                                      style: AppStyles.heading4.copyWith(
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : Text(
                                      state!,
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
