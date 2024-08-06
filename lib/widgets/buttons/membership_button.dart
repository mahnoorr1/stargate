import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/screens/profile/membership_screen.dart';

class MembershipButton extends StatefulWidget {
  final Color textColor;
  const MembershipButton({
    super.key,
    this.textColor = AppColors.blue,
  });

  @override
  State<MembershipButton> createState() => _MembershipButtonState();
}

class _MembershipButtonState extends State<MembershipButton> {
  bool isHovered = false;
  void onMembershipTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MembershipScreen(),
      ),
    );
  }

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
                      style:
                          AppStyles.heading4.copyWith(color: widget.textColor),
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
            margin: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20.w),
              ),
              color: AppColors.lightBlue.withOpacity(0.5),
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
