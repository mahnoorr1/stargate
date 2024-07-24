import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/utils/app_images.dart';

class FilterButton extends StatefulWidget {
  final void Function() onTap;
  const FilterButton({
    super.key,
    required this.onTap,
  });

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.w),
          color: AppColors.darkBlue,
        ),
        height: 60,
        width: double.infinity,
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 16.w),
              Text(
                "Filter",
                style: AppStyles.heading3.copyWith(
                  color: Colors.white,
                ),
              ),
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.w),
                  color: AppColors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    AppIcons.filter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
