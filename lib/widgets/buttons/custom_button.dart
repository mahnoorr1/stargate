import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stargate/config/core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double? width;
  final double? height;
  final bool? nextIcon;
  final VoidCallback? onPressed;
  final Color? color;
  const CustomButton({
    super.key,
    required this.text,
    this.width,
    this.nextIcon = false,
    this.height,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width ?? 360.w,
        height: height ?? 50.w,
        decoration: ShapeDecoration(
          color: color ?? AppColors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Platform.isIOS
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        text,
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ),
                    )
                  : Text(
                      text,
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ),
              if (nextIcon == true)
                Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: Platform.isIOS
                      ? const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.white,
                          size: 20,
                        )
                      : const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
