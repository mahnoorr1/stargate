import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/config/core.dart';

class BubbleTextButton extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  const BubbleTextButton({
    super.key,
    required this.text,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.w),
      margin: EdgeInsets.only(right: 6.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(40.w),
        ),
        color: AppColors.lightBlue.withOpacity(0.6),
      ),
      child: Text(
        text,
        style: textStyle ??
            AppStyles.normalText.copyWith(
              color: AppColors.darkBlue,
            ),
      ),
    );
  }
}
