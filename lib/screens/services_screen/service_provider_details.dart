// ignore_for_file: unnecessary_null_comparison, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/models/user.dart';
import 'package:stargate/providers/service_providers_provider.dart';
import 'package:stargate/screens/services_screen/widgets/experience_card.dart';
import 'package:stargate/utils/app_enums.dart';
import 'package:stargate/utils/app_images.dart';
import 'package:stargate/widgets/buttons/back_button.dart';
import 'package:stargate/widgets/buttons/bubble_text_button.dart';
import 'package:stargate/widgets/buttons/custom_button.dart';
import 'package:stargate/widgets/buttons/membership_button.dart';
import 'package:stargate/widgets/custom_toast.dart';
import 'package:stargate/widgets/pdf_thumbnail.dart';

import '../../widgets/inputfields/textfield.dart';

class ServiceProviderDetails extends StatefulWidget {
  final User user;
  const ServiceProviderDetails({super.key, required this.user});

  @override
  State<ServiceProviderDetails> createState() => _ServiceProviderDetailsState();
}

class _ServiceProviderDetailsState extends State<ServiceProviderDetails> {
  final TextEditingController _emailMessageController = TextEditingController();
  _onEmailMessageSendSuccess() {
    Navigator.pop(context);
    showToast(
        message: "Message Sent Successfully to ${widget.user.name}",
        context: context);
  }

  _onError() {
    showToast(message: "Something Went Wrong", context: context);
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
                      child: widget.user.image != ''
                          ? Image(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.45,
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                widget.user.image!,
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.45,
                              color: AppColors.lightGrey,
                              child: Image.asset(AppImages.user),
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
                          ...widget.user.services.map(
                            (service) => BubbleTextButton(
                              text: service.details['name'],
                              textStyle: AppStyles.heading4.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.42,
                        left: MediaQuery.of(context).size.width * 0.025,
                        right: MediaQuery.of(context).size.width * 0.025,
                      ),
                      width: MediaQuery.of(context).size.width * 0.95,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 20.w),
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
                                width: MediaQuery.of(context).size.width * 0.72,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.user.name,
                                      style: AppStyles.heading3,
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
                                              0.65,
                                          child: widget.user.address != ''
                                              ? Text(
                                                  widget.user.address!,
                                                  maxLines: 2,
                                                  style:
                                                      AppStyles.supportiveText,
                                                )
                                              : const Text("No Address"),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Container(
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
                            ],
                          ),
                          SizedBox(height: 16.w),
                          widget.user.services.length == 1 &&
                                  widget.user.containsServiceUserType(
                                      UserType.investor)
                              ? investorContent()
                              : widget.user.containsServiceUserType(
                                      UserType.investor)
                                  ? investorAndMoreContent()
                                  : notInvestorContent(),
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
            child: const MembershipButton(
              textColor: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget investorContent() {
    Service? investorService = widget.user.services.firstWhere(
      (service) => service.details['name'] == 'Investor',
    );

    var min = 0;
    var max = 0;
    // ignore: unnecessary_null_comparison
    if (investorService != null) {
      if (investorService.details['investmentRange'] != null) {
        min = investorService.details['investmentRange']['min'] ?? 0;
        max = investorService.details['investmentRange']['max'] ?? 0;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        investorService != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Investment Range",
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
                        "$min - $max", // Show min and max values
                        style:
                            AppStyles.heading4.copyWith(color: AppColors.blue),
                      ),
                    ],
                  ),
                ],
              )
            : const SizedBox(),
        SizedBox(height: 12.w),
        Text(
          "Investment priorities",
          style: AppStyles.supportiveText.copyWith(
            color: AppColors.primaryGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.w),
        const Row(
          children: [
            BubbleTextButton(text: "commercial"),
          ],
        ),
        SizedBox(height: 12.w),
        Text(
          "References",
          style: AppStyles.supportiveText.copyWith(
            color: AppColors.primaryGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.w),
        const PdfThumbnail(),
        SizedBox(height: 16.w),
        Text(
          "Contact on my website",
          style: AppStyles.heading4.copyWith(color: AppColors.blue),
        ),
        SizedBox(height: 16.w),
        CustomButton(
            onPressed: () {
              showCustomBottomSheet(
                  context: context, child: _sendEmailMessage());
            },
            text: "Send Mail"),
      ],
    );
  }

  Widget notInvestorContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Specialized Experience",
          style: AppStyles.supportiveText.copyWith(
            color: AppColors.primaryGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.w),
        ...widget.user.services.map(
          (service) => ExperienceCard(
            title: service.details['name'],
            subTitle: service.details['specialization'],
            noOfYears: service.details['yearsOfExperience'],
          ),
        ),
        SizedBox(height: 12.w),
        Text(
          "References",
          style: AppStyles.supportiveText.copyWith(
            color: AppColors.primaryGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.w),
        const PdfThumbnail(),
        SizedBox(height: 16.w),
        Text(
          "contact on my website",
          style: AppStyles.heading4.copyWith(color: AppColors.blue),
        ),
        SizedBox(height: 16.w),
        CustomButton(
            onPressed: () {
              showCustomBottomSheet(
                  context: context, child: _sendEmailMessage());
            },
            text: "Send Mail"),
      ],
    );
  }

  Widget investorAndMoreContent() {
    // Check if the user has an investment service
    Service? investmentService = widget.user.services.firstWhere((service) =>
        service.details['name'] == 'Investor' &&
        service.details['investmentRange']['min'] != 0 &&
        service.details['investmentRange']['max'] != 0);

    // Fetch min and max investment values
    var min = investmentService != null
        ? investmentService.details['investmentRange']['min']
        : 0;
    var max = investmentService != null
        ? investmentService.details['investmentRange']['max']
        : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Investment Range",
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
              "$min - $max", // Dynamically display the investment range
              style: AppStyles.heading4.copyWith(color: AppColors.blue),
            ),
          ],
        ),
        SizedBox(height: 12.w),
        Text(
          "Investment priorities",
          style: AppStyles.supportiveText.copyWith(
            color: AppColors.primaryGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.w),
        const Row(
          children: [
            BubbleTextButton(text: "commercial"),
          ],
        ),
        SizedBox(height: 12.w),
        Text(
          "Specialized Experience",
          style: AppStyles.supportiveText.copyWith(
            color: AppColors.primaryGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.w),
        ...widget.user.services.map(
          (service) => ExperienceCard(
            title: service.details['name'],
            subTitle: service.details['specialization'],
            noOfYears: service.details['yearsOfExperience'],
          ),
        ),
        SizedBox(height: 12.w),
        Text(
          "References",
          style: AppStyles.supportiveText.copyWith(
            color: AppColors.primaryGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.w),
        const PdfThumbnail(),
        SizedBox(height: 16.w),
        Text(
          "contact on my website",
          style: AppStyles.heading4.copyWith(color: AppColors.blue),
        ),
        SizedBox(height: 16.w),
        const CustomButton(text: "Send Mail"),
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
                const Text(
                  "Send Message",
                  style: AppStyles.heading3,
                ),
                SizedBox(height: 12.w),
                CustomTextField(
                  controller: _emailMessageController,
                  label: "Message",
                  hintText: "Write your Message",
                  inputType: TextInputType.text,
                  horizontalSpacing: 0,
                  maxLines: 3,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: CustomButton(
                    text: "Send",
                    onPressed: () async {
                      if (_emailMessageController.text.isEmpty) {
                        showToast(
                            message: "Please Enter Message", context: context);
                      } else {
                        var res = await context
                            .read<AllUsersProvider>()
                            .sendEmail(
                                userId: widget.user.id,
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
