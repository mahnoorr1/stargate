import 'package:flutter/material.dart';
import 'package:stargate/config/core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/screens/property_request_screen/property_request_screen.dart';
import 'package:stargate/utils/app_images.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 180,
              width: double.infinity,
              color: AppColors.darkBlue,
            ),
            SizedBox(
              height: 20.w,
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150.w,
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10.w),
                      boxShadow: [
                        AppStyles.boxShadow,
                      ],
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          AppImages.sale,
                          width: MediaQuery.of(context).size.width * 0.25,
                        ),
                        SizedBox(
                          width: 12.w,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.55,
                              child: Text(
                                "Do you want to sale property or request it?",
                                style: AppStyles.heading3.copyWith(
                                  color: AppColors.darkBlue,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: 8.w,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: const Text(
                                "sale/ rent your property at best price",
                                style: AppStyles.supportiveText,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: 8.w,
                            ),
                            GestureDetector(
                              onTap: () =>
                                  Navigator.of(context, rootNavigator: false)
                                      .push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PropertyRequestForm(),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Create Offer",
                                    style: AppStyles.heading4
                                        .copyWith(color: AppColors.darkBlue),
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  const Icon(
                                    Icons.arrow_forward,
                                    color: AppColors.darkBlue,
                                    size: 18,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
