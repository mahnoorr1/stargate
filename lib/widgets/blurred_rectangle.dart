import 'package:flutter/material.dart';
import 'package:stargate/config/core.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlurredRectangle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const BlurredRectangle({super.key, required this.title, this.subtitle});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: AppColors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: AppStyles.heading4.copyWith(
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle != null
                            ? Text(
                                subtitle!,
                                style: AppStyles.supportiveText.copyWith(
                                  color: AppColors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              )
                            : const SizedBox(),
                      ],
                    ),
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
