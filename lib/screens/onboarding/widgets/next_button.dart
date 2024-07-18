import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/config/core.dart';

class NextButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final int index;
  const NextButton({
    super.key,
    required this.onPressed,
    required this.index,
  });

  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  final decorator = DotsDecorator(
    activeColor: AppColors.blue,
    size: const Size.square(10.0),
    activeSize: const Size.square(15.0),
    activeShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25.0),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            child: DotsIndicator(
              dotsCount: 3,
              position: widget.index,
              axis: Axis.horizontal,
              decorator: decorator,
            ),
          ),
          Row(
            children: [
              widget.index == 2
                  ? const SizedBox()
                  : GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text(
                        "Skip",
                        style: AppStyles.heading4.copyWith(
                          color: AppColors.darkBlue,
                        ),
                      ),
                    ),
              SizedBox(
                width: 20.w,
              ),
              widget.index != 2
                  ? Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.w),
                        color: AppColors.lightBlue,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_forward,
                          color: AppColors.darkBlue,
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 150.w,
                      height: 50.w,
                      child: Stack(
                        children: [
                          Positioned(
                            right: 1,
                            child: Container(
                              height: 50.w,
                              width: 90.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.w),
                                color: AppColors.lightBlue,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 1,
                            bottom: 10,
                            top: 10,
                            child: Text(
                              "Get Started",
                              style: AppStyles.heading3
                                  .copyWith(color: AppColors.darkBlue),
                            ),
                          )
                        ],
                      ),
                    ),
            ],
          )
        ],
      ),
    );
  }
}
