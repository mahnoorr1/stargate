// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/providers/service_providers_provider.dart';
import 'package:stargate/screens/forget%20password/forget_pass.dart';
import 'package:stargate/screens/otp_screen/otp_Screen.dart';
import 'package:stargate/services/user_profiling.dart';
import 'package:stargate/utils/app_images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/widgets/buttons/custom_button.dart';
import 'package:stargate/widgets/custom_toast.dart';
import 'package:stargate/widgets/inputfields/underlined_textfield.dart';
import 'package:stargate/widgets/loader/loader.dart';

import '../../providers/real_estate_provider.dart';
import '../../widgets/screen/screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool login = false;
  final formKey = GlobalKey<FormState>();

  void onForgetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ForgetPass(),
      ),
    );
  }

  bool isValidEmail() {
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
    return emailRegex.hasMatch(email.text);
  }

  void onSignIn() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      showToast(
        message: "Please enter all fields!",
        context: context,
        isAlert: true,
        color: Colors.redAccent,
      );
    } else if (!isValidEmail()) {
      showToast(
        message: "Invalid Email!",
        context: context,
        isAlert: true,
        color: Colors.redAccent,
      );
    } else {
      setState(() {
        login = true;
      });
      String? loggedIn = await loginUser(email.text, password.text);
      if (loggedIn == 'token') {
        await AllUsersProvider.c(context).fetchUsers();
        await RealEstateProvider.c(context).fetchAllListings();
        Navigator.popAndPushNamed(context, '/navbar');
        showToast(message: "Login successful", context: context);
      } else {
        setState(() {
          login = false;
        });
        showToast(
          message: loggedIn!,
          context: context,
          isAlert: true,
          color: Colors.redAccent,
        );
        if (loggedIn == 'Email not verified') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OTPScreen(
                email: email.text,
                password: password.text,
              ),
            ),
          );
        }
      }
    }
  }

  void onSignUp() {
    Navigator.popAndPushNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      overlayWidgets: [
        if (login)
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
                        "Welcome!",
                        style: AppStyles.heading1.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Login to continue",
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
                              controller: email,
                              label: "Email",
                              hintText: "Enter email",
                              inputType: TextInputType.emailAddress,
                              icon: Icons.email_outlined,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 6.w),
                            UnderlinedTextField(
                              controller: password,
                              label: "Password",
                              hintText: "Enter Password",
                              inputType: TextInputType.text,
                              obscureText: true,
                              prefixSvgPath: AppIcons.lock,
                            ),
                            SizedBox(height: 12.w),
                            GestureDetector(
                              onTap: onForgetPassword,
                              child: Text(
                                "Forgot Password?",
                                style: AppStyles.normalText.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            const Spacer(),
                            CustomButton(
                                text: "Sign In",
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    onSignIn();
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an Account?",
                          style: AppStyles.normalText.copyWith(
                            color: AppColors.backgroundColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: onSignUp,
                          child: Text(
                            "Sign Up here",
                            style: AppStyles.heading4.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
