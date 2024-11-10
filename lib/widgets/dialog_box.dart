import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../config/core.dart';
import '../utils/app_images.dart';
import 'buttons/custom_button.dart';

class CustomDialog extends StatelessWidget {
  final Color circleBackgroundColor;
  final String titleText;
  final Color? titleColor;
  final String descriptionText;
  final String? topTitleText;
  final Color? topTitleColor;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final String? asset;

  const CustomDialog({
    super.key,
    required this.circleBackgroundColor,
    required this.titleText,
    this.titleColor,
    required this.descriptionText,
    this.topTitleText,
    this.topTitleColor,
    this.buttonText,
    this.onButtonPressed,
    this.asset,
  });
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.fromLTRB(16, 70, 16, 16),
            margin: const EdgeInsets.only(top: 50),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20.w),
                Text(
                  titleText,
                  style: TextStyle(
                      fontSize: 20,
                      color: titleColor ?? Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 12.w),
                topTitleText != null
                    ? Text(
                        topTitleText!,
                        style: TextStyle(
                            fontSize: 32,
                            letterSpacing: 6,
                            color: topTitleColor ?? Colors.black,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Montserrat'),
                      )
                    : const SizedBox(),
                topTitleText != null
                    ? SizedBox(height: 12.w)
                    : const SizedBox(),
                SizedBox(height: 12.w),
                Text(
                  descriptionText,
                  textAlign: TextAlign.center,
                  style: AppStyles.normalText,
                ),
                SizedBox(
                  height: 24.w,
                ),
                buttonText != null
                    ? CustomButton(
                        text: buttonText!,
                        onPressed: onButtonPressed,
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          Positioned(
            top: -30,
            child: Container(
              width: 175,
              height: 175,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: 170,
                  height: 170,
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: circleBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox(
                    width: 160,
                    height: 160,
                    child: asset != null
                        ? Image.asset(
                            asset!,
                            fit: BoxFit.cover,
                          )
                        : SvgPicture.asset(AppIcons.alert),
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

void showCustomDialog({
  required BuildContext context,
  required Color circleBackgroundColor,
  required String titleText,
  Color? titleColor,
  required String descriptionText,
  String? topTitleText,
  Color? topTitleColor,
  String? buttonText,
  VoidCallback? onButtonPressed,
  String? asset,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomDialog(
        circleBackgroundColor: circleBackgroundColor,
        titleText: titleText,
        titleColor: titleColor,
        descriptionText: descriptionText,
        topTitleText: topTitleText,
        topTitleColor: topTitleColor,
        buttonText: buttonText,
        onButtonPressed: onButtonPressed,
        asset: asset,
      );
    },
  );
}
