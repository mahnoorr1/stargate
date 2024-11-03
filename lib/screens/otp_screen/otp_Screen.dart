// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/utils/app_images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/widgets/buttons/custom_button.dart';
import 'package:stargate/widgets/custom_toast.dart';
import 'package:stargate/widgets/inputfields/underlined_textfield.dart';
import 'package:stargate/widgets/loader/loader.dart';

import '../../services/user_profiling.dart';
import '../../widgets/screen/screen.dart';

// ignore: must_be_immutable
class OTPScreen extends StatefulWidget {
  String? name;
  String email;
  String password;
  String? profession;
  OTPScreen({
    super.key,
    required this.email,
    this.name,
    required this.password,
    this.profession,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otp = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool verifying = false;

  void verifyOtp() async {
    setState(() {
      verifying = true;
    });
    String? result = await verifyOTP(otp.text, widget.email);
    if (result == 'Email verified, login to continue!') {
      showToast(message: result, context: context);
      setState(() {
        verifying = false;
      });
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      setState(() {
        verifying = false;
      });
      showToast(
        message: result,
        context: context,
        isAlert: true,
        color: Colors.redAccent,
      );
    }
  }

  void onVerfified() {
    Navigator.popAndPushNamed(context, '/navbar');
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      overlayWidgets: [
        if (verifying)
          const FullScreenLoader(
            loading: true,
          )
      ],
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              AppImages.house,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              // ignore: deprecated_member_use
              color: AppColors.black.withOpacity(0.5),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Verify OTP",
                        style: AppStyles.heading1.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Input the 6-digit code that has been emailed to you.",
                        style: AppStyles.heading3.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 300.w,
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.w),
                        color: AppColors.lightBlue,
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 24.w,
                            ),
                            UnderlinedTextField(
                              controller: otp,
                              label: "Enter otp",
                              hintText: "Enter otp",
                              inputType: TextInputType.number,
                              icon: Icons.password,
                            ),
                            SizedBox(height: 12.w),
                            const Spacer(),
                            CustomButton(
                              text: "Verify",
                              onPressed: () {
                                if (otp.text.isNotEmpty) {
                                  verifyOtp();
                                } else {
                                  showToast(
                                    message: "Please Enter OTP!",
                                    context: context,
                                    isAlert: true,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
