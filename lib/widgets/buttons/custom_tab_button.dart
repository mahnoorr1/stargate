import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/localization/localization.dart';
import 'package:stargate/localization/translation_strings.dart';

// ignore: must_be_immutable
class CustomTabButton extends StatefulWidget {
  final Function(String) selected;
  final String current;
  final String type;

  const CustomTabButton({
    super.key,
    required this.selected,
    required this.type,
    required this.current,
  });

  @override
  State<CustomTabButton> createState() => _CustomTabButtonState();
}

class _CustomTabButtonState extends State<CustomTabButton> {
  @override
  Widget build(BuildContext context) {
    bool isSelected = widget.type == widget.current;

    return GestureDetector(
      onTap: () {
        setState(() {
          widget.selected(widget.type);
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 10.w, bottom: 12.w),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          color: isSelected ? AppColors.blue : AppColors.lightBlue,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.w),
          child: Center(
            child: Text(
              widget.type == 'new'
                  ? AppLocalization.of(context)!
                      .translate(TranslationString.neww)
                  : widget.type == 'below 5 years'
                      ? AppLocalization.of(context)!
                          .translate(TranslationString.below5years)
                      : widget.type == 'above 5 years'
                          ? AppLocalization.of(context)!
                              .translate(TranslationString.above5years)
                          : widget.type == '5 years'
                              ? AppLocalization.of(context)!
                                  .translate(TranslationString.years5)
                              : AppLocalization.of(context)!.translate(
                                  widget.type,
                                ),
              style: isSelected
                  ? AppStyles.heading4.copyWith(color: AppColors.white)
                  : AppStyles.normalText,
            ),
          ),
        ),
      ),
    );
  }
}
