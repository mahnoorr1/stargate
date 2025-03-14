import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/models/real_estate_listing.dart';
import 'package:stargate/utils/app_images.dart';
import 'package:stargate/widgets/buttons/back_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/widgets/buttons/bubble_text_button.dart';
import 'package:stargate/widgets/custom_toast.dart';

import '../../localization/localization.dart';
import '../../localization/translation_strings.dart';
import '../../providers/service_providers_provider.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/inputfields/textfield.dart';
import '../../widgets/translationWidget.dart';

class ListingDetailsScreen extends StatefulWidget {
  final RealEstateListing listing;
  const ListingDetailsScreen({
    super.key,
    required this.listing,
  });

  @override
  State<ListingDetailsScreen> createState() => _ListingDetailsScreenState();
}

class _ListingDetailsScreenState extends State<ListingDetailsScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _emailMessageController = TextEditingController();
  _onEmailMessageSendSuccess() {
    Navigator.pop(context);
    showToast(
        message:
            "${AppLocalization.of(context)!.translate(TranslationString.messageSentSuccessfullyTo)} ${widget.listing.userName}",
        context: context);
  }

  _onError() {
    showToast(
        message: AppLocalization.of(context)!
            .translate(TranslationString.somethingWentWrong),
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30.w),
                        bottomRight: Radius.circular(30.w),
                      ),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: widget.listing.pictures.length,
                          itemBuilder: (context, index) {
                            return Image(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.45,
                              fit: BoxFit.cover,
                              image:
                                  NetworkImage(widget.listing.pictures[index]),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.4,
                        left: MediaQuery.of(context).size.width * 0.45,
                        right: MediaQuery.of(context).size.width * 0.45,
                      ),
                      child: Center(
                        child: SmoothPageIndicator(
                          controller: _pageController,
                          count: widget.listing.pictures.length,
                          effect: const WormEffect(
                            dotHeight: 12,
                            dotWidth: 12,
                            activeDotColor: Colors.white,
                            dotColor: AppColors.lightGrey,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.36,
                        left: MediaQuery.of(context).size.width * 0.025,
                        right: MediaQuery.of(context).size.width * 0.025,
                      ),
                      child: Row(
                        children: [
                          BubbleTextButton(
                            child: Text(
                                AppLocalization.of(context)!
                                    .translate(widget.listing.propertyType),
                                style: AppStyles.heading4.copyWith(
                                  color: AppColors.white,
                                )),
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          BubbleTextButton(
                            child: Text(
                              AppLocalization.of(context)!
                                  .translate(widget.listing.sellingType),
                              style: AppStyles.heading4.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.42,
                        left: MediaQuery.of(context).size.width * 0.025,
                        right: MediaQuery.of(context).size.width * 0.02,
                      ),
                      width: MediaQuery.of(context).size.width * 0.96,
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 20.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.w),
                        color: AppColors.white,
                        boxShadow: [AppStyles.boxShadow],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.86,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.61,
                                            child: translationWidget(
                                              widget.listing.title,
                                              context,
                                              widget.listing.title,
                                              AppStyles.heading3,
                                            )),
                                        const Spacer(),
                                        BubbleTextButton(
                                          child: Text(
                                            widget.listing.requestType ==
                                                    'requesting'
                                                ? AppLocalization.of(context)!
                                                    .translate(TranslationString
                                                        .request)
                                                : AppLocalization.of(context)!
                                                    .translate(TranslationString
                                                        .offer),
                                            style:
                                                AppStyles.normalText.copyWith(
                                              color: AppColors.darkBlue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.w),
                                    Row(
                                      children: [
                                        SvgPicture.asset(AppIcons.location),
                                        SizedBox(width: 4.w),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.79,
                                          child: Text(
                                            widget.listing.address,
                                            maxLines: 2,
                                            style: AppStyles.supportiveText,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 4.w),
                            ],
                          ),
                          SizedBox(height: 16.w),
                          listingContent(),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.w),
              ],
            ),
          ),
          Positioned(
            top: 36.w,
            left: 16.w,
            child: const CustomBackButton(),
          ),
          Positioned(
            top: 36.w,
            right: 16.w,
            child: Container(
              height: 30,
              margin: EdgeInsets.only(top: 4.w),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: widget.listing.status == 'pending'
                    ? Colors.orange
                    : widget.listing.status == 'rejected'
                        ? Colors.redAccent
                        : AppColors.blue,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  "${AppLocalization.of(context)!.translate(TranslationString.approval)} ${AppLocalization.of(context)!.translate(widget.listing.status)}",
                  style: AppStyles.heading4.copyWith(color: AppColors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget translationString(String value) {
    return FutureBuilder<String>(
      future: translatedText(value, context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 10,
              height: 10,
            ),
          );
        } else if (snapshot.hasError) {
          return Text(
            value,
            style: AppStyles.normalText.copyWith(color: AppColors.darkBlue),
          );
        } else if (snapshot.hasData) {
          return Text(
            snapshot.data!,
            style: AppStyles.normalText,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxLines: 6,
          );
        } else {
          return Text(
            value,
            style: AppStyles.normalText.copyWith(color: AppColors.darkBlue),
          );
        }
      },
    );
  }

  String formatPrice(double price) {
    final NumberFormat formatter = NumberFormat("###,###", "de_DE");
    String formattedPrice = formatter.format(price).replaceAll(',', ' ');
    return formattedPrice;
  }

  Widget listingContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalization.of(context)!
                      .translate(TranslationString.category),
                  style: AppStyles.supportiveText,
                ),
                SizedBox(
                  height: 6.w,
                ),
                BubbleTextButton(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: translationString(widget.listing.propertyCategory),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalization.of(context)!
                      .translate(TranslationString.subcategory),
                  style: AppStyles.supportiveText,
                ),
                SizedBox(
                  height: 6.w,
                ),
                BubbleTextButton(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: translationString(
                          widget.listing.propertySubCategory)),
                ),
              ],
            )
          ],
        ),
        SizedBox(
          height: 8.w,
        ),
        Text(
          AppLocalization.of(context)!.translate(TranslationString.price),
          style: AppStyles.supportiveText.copyWith(
            color: AppColors.primaryGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6.w),
        Row(
          children: [
            Image.asset(AppIcons.cash, width: 30.w),
            SizedBox(width: 8.w),
            Text(
              "€ ${formatPrice(widget.listing.price)}",
              style: AppStyles.heading4.copyWith(color: AppColors.blue),
            ),
          ],
        ),
        SizedBox(
          height: 12.w,
        ),
        Row(
          children: [
            Image.asset(
              AppImages.bed,
            ),
            SizedBox(
              width: 8.w,
            ),
            Text(
              widget.listing.noOfBeds.toString(),
              style: AppStyles.heading4,
            ),
            SizedBox(
              width: 24.w,
            ),
            Image.asset(
              AppImages.bath,
            ),
            SizedBox(
              width: 8.w,
            ),
            Text(
              widget.listing.noOfBathrooms.toString(),
              style: AppStyles.heading4,
            ),
          ],
        ),
        SizedBox(
          height: 12.w,
        ),
        SizedBox(
          width: double.infinity,
          child: FutureBuilder<String>(
            future: translatedText(widget.listing.description, context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 10,
                    height: 10,
                  ),
                );
              } else if (snapshot.hasError) {
                return Text(
                  widget.listing.description,
                  style: AppStyles.normalText
                      .copyWith(color: AppColors.primaryGrey),
                );
              } else if (snapshot.hasData) {
                return Text(
                  snapshot.data!,
                  style: AppStyles.normalText,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                );
              } else {
                return Text(
                  widget.listing.description,
                  style: AppStyles.normalText
                      .copyWith(color: AppColors.primaryGrey),
                );
              }
            },
          ),
        ),
        SizedBox(
          height: 20.w,
        ),
        Text(
          AppLocalization.of(context)!
              .translate(TranslationString.otherDetails),
          style: AppStyles.heading4,
        ),
        SizedBox(
          height: 8.w,
        ),
        Row(
          children: [
            Text(
              AppLocalization.of(context)!
                  .translate(TranslationString.conditionSmallWithColon),
              style: AppStyles.normalText,
            ),
            const Spacer(),
            Text(
              widget.listing.condition,
              style: AppStyles.normalText.copyWith(
                color: AppColors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8.w,
        ),
        Row(
          children: [
            Text(
              AppLocalization.of(context)!
                  .translate(TranslationString.landArea),
              style: AppStyles.normalText,
            ),
            const Spacer(),
            Text.rich(
              TextSpan(
                text:
                    "${widget.listing.landAreaInTotal!.toInt() + widget.listing.occupiedLandArea!.toInt()} m",
                style: AppStyles.normalText.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                children: const <TextSpan>[
                  TextSpan(
                    text: '²',
                    style: TextStyle(
                      fontSize: 12,
                      fontFeatures: [FontFeature.superscripts()],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: 8.w,
        ),
        Row(
          children: [
            Text(
              AppLocalization.of(context)!
                  .translate(TranslationString.builableArea),
              style: AppStyles.normalText,
            ),
            const Spacer(),
            Text.rich(
              TextSpan(
                text: "${widget.listing.landAreaInTotal!.toInt()} m",
                style: AppStyles.normalText.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                children: const <TextSpan>[
                  TextSpan(
                    text: '²',
                    style: TextStyle(
                      fontSize: 12,
                      fontFeatures: [FontFeature.superscripts()],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: 8.w,
        ),
        Row(
          children: [
            Text(
              AppLocalization.of(context)!
                  .translate(TranslationString.buildingUsageArea),
              style: AppStyles.normalText,
            ),
            const Spacer(),
            Text.rich(
              TextSpan(
                text: "${widget.listing.occupiedLandArea!.toInt()} m",
                style: AppStyles.normalText.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                children: const <TextSpan>[
                  TextSpan(
                    text: '²',
                    style: TextStyle(
                      fontSize: 12,
                      fontFeatures: [FontFeature.superscripts()],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: 8.w,
        ),
        Row(
          children: [
            Text(
              AppLocalization.of(context)!
                  .translate(TranslationString.furnished),
              style: AppStyles.normalText,
            ),
            const Spacer(),
            Text(
              widget.listing.furnished!
                  ? AppLocalization.of(context)!
                      .translate(TranslationString.yes)
                  : AppLocalization.of(context)!
                      .translate(TranslationString.no),
              style: AppStyles.normalText.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8.w,
        ),
        widget.listing.propertyType == 'commercial'
            ? Row(
                children: [
                  Text(
                    AppLocalization.of(context)!
                        .translate(TranslationString.noOfParkingPlaces),
                    style: AppStyles.normalText,
                  ),
                  const Spacer(),
                  widget.listing.parkingPlaces != null
                      ? Text(
                          widget.listing.parkingPlaces!.toString(),
                          style: AppStyles.normalText.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Text(
                          "0",
                          style: AppStyles.normalText.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ],
              )
            : Row(
                children: [
                  Text(
                    AppLocalization.of(context)!
                        .translate(TranslationString.garage),
                    style: AppStyles.normalText,
                  ),
                  const Spacer(),
                  Text(
                    widget.listing.garage!
                        ? AppLocalization.of(context)!
                            .translate(TranslationString.yes)
                        : AppLocalization.of(context)!
                            .translate(TranslationString.no),
                    style: AppStyles.normalText.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
        SizedBox(
          height: 20.w,
        ),
        widget.listing.propertyType == 'commercial'
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalization.of(context)!
                        .translate(TranslationString.equipmentDetails),
                    style: AppStyles.heading4,
                  ),
                  SizedBox(
                    height: 8.w,
                  ),
                ],
              )
            : const SizedBox(),
        widget.listing.equipment == '' &&
                widget.listing.qualityOfEquipment == '' &&
                widget.listing.propertyType == 'commercial'
            ? Text(
                AppLocalization.of(context)!
                    .translate(TranslationString.noEquipment),
                style: AppStyles.normalText,
              )
            : widget.listing.propertyType == 'commercial'
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.listing.equipment != ''
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalization.of(context)!
                                      .translate(TranslationString.equipment),
                                  style: AppStyles.supportiveText,
                                ),
                                SizedBox(
                                  height: 6.w,
                                ),
                                translationWidget(
                                  widget.listing.equipment!,
                                  context,
                                  widget.listing.equipment!,
                                  AppStyles.normalText,
                                )
                              ],
                            )
                          : const SizedBox(),
                      widget.listing.equipment != ''
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalization.of(context)!.translate(
                                      TranslationString.qualityOfEquipment),
                                  style: AppStyles.supportiveText,
                                ),
                                SizedBox(
                                  height: 6.w,
                                ),
                                translationWidget(
                                  widget.listing.qualityOfEquipment!,
                                  context,
                                  widget.listing.qualityOfEquipment!,
                                  AppStyles.normalText,
                                )
                              ],
                            )
                          : const SizedBox(),
                    ],
                  )
                : const SizedBox(),
        SizedBox(
          height: 20.w,
        ),
        Row(
          children: [
            Text(
              widget.listing.userName,
              style: AppStyles.heading4,
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                showCustomBottomSheet(
                    context: context, child: _sendEmailMessage());
              },
              child: Container(
                height: 50.w,
                width: 50.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.w),
                  // ignore: deprecated_member_use
                  color: AppColors.lightBlue.withOpacity(0.3),
                ),
                child: const Center(
                  child: Icon(
                    Icons.email_outlined,
                    color: AppColors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _sendEmailMessage() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalization.of(context)!
                      .translate(TranslationString.sendMessage),
                  style: AppStyles.heading3,
                ),
                SizedBox(height: 12.w),
                CustomTextField(
                  controller: _emailMessageController,
                  label: AppLocalization.of(context)!
                      .translate(TranslationString.message),
                  hintText: AppLocalization.of(context)!
                      .translate(TranslationString.writeYourMessage),
                  inputType: TextInputType.text,
                  horizontalSpacing: 0,
                  maxLines: 3,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: CustomButton(
                    text: AppLocalization.of(context)!
                        .translate(TranslationString.send),
                    onPressed: () async {
                      if (_emailMessageController.text.isEmpty) {
                        showToast(
                            message: AppLocalization.of(context)!.translate(
                                TranslationString.pleaseEnterMessage),
                            context: context);
                      } else {
                        var res = await context
                            .read<AllUsersProvider>()
                            .sendEmail(
                                userId: widget.listing.userID,
                                message: _emailMessageController.text);

                        res ? _onEmailMessageSendSuccess() : _onError();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showCustomBottomSheet(
      {required BuildContext context, required Widget child}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled:
          true, // Allows the bottom sheet to resize when the keyboard opens
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context)
              .viewInsets
              .bottom, // Adjusts for the keyboard
        ),
        child: child,
      ),
    );
  }
}
