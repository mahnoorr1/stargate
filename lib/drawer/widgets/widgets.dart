import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/config/core.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.backgroundColor,
      leading: GestureDetector(
        onTap: () => Navigator.pushNamedAndRemoveUntil(
            context, '/navbar', (route) => false),
        child: Container(
          height: 20.w,
          width: 20.w,
          margin: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.w),
            color: AppColors.lightBlue,
          ),
          child: const Center(
            child: Icon(
              Icons.arrow_back,
            ),
          ),
        ),
      ),
    );
  }
}

class Heading extends StatelessWidget {
  final String heading;
  const Heading({super.key, required this.heading});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          heading,
          style: AppStyles.heading2,
          maxLines: 2,
        ),
      ),
    );
  }
}
