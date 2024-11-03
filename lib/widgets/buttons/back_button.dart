import 'package:flutter/material.dart';
import 'package:stargate/config/core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBackButton extends StatelessWidget implements PreferredSizeWidget {
  final Color? color;
  const CustomBackButton({
    super.key,
    this.color,
  });
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 40.w,
        width: 40.w,
        margin: EdgeInsets.all(6.w),
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.w),
          // ignore: deprecated_member_use
          color: AppColors.lightBlue.withOpacity(0.5),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back,
            color: color ?? AppColors.white,
          ),
        ),
      ),
    );
  }
}
