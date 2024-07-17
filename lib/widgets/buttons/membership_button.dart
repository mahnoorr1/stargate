import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/config/core.dart';

class MembershipButton extends StatefulWidget {
  const MembershipButton({super.key});

  @override
  State<MembershipButton> createState() => _MembershipButtonState();
}

class _MembershipButtonState extends State<MembershipButton> {
  bool isHovered = false;
  void onMembershipTap() {}
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isHovered
            ? GestureDetector(
                onTap: onMembershipTap,
                child: Container(
                  height: 40.w,
                  width: 120.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.w),
                    ),
                    color: AppColors.lightBlue,
                  ),
                  child: Center(
                    child: Text(
                      "membership",
                      style: AppStyles.heading4.copyWith(color: AppColors.blue),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        SizedBox(
          width: 10.w,
        ),
        InkWell(
          onTap: () {
            setState(() {
              isHovered = !isHovered;
            });
          },
          child: Container(
            height: 40.w,
            width: 40.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20.w),
              ),
              color: AppColors.lightBlue,
            ),
            child: Icon(
              Icons.star,
              color: Colors.amber[600],
            ),
          ),
        ),
      ],
    );
  }
}
