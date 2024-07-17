import 'package:flutter/material.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/utils/app_images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/widgets/buttons/custom_button.dart';
import 'package:stargate/widgets/inputfields/underlined_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void onForgetPassword() {}

  void onSignIn() {}
  void onSignUp() {
    Navigator.popAndPushNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                          onPressed: onSignIn,
                        ),
                      ],
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
    );
  }
}
