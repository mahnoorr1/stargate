// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/services/user_profiling.dart';
import 'package:stargate/utils/app_images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/widgets/buttons/custom_button.dart';
import 'package:stargate/widgets/custom_toast.dart';
import 'package:stargate/widgets/inputfields/dropdown.dart';
import 'package:stargate/widgets/inputfields/underlined_textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController profession = TextEditingController();

  List<String> professions = [
    'Select Profession',
    'Notary',
    'Investor',
    'Real Estate Agent',
    'Lawyer',
    'Appraiser',
    'Other'
  ];

  bool registerSuccess = false;

  void onSignIn() {
    Navigator.popAndPushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    void onSignUp() async {
      String? register = await registerUser(
          name.text, email.text, password.text, profession.text);
      if (register == 'token') {
        registerSuccess = true;
        Navigator.pushReplacementNamed(context, '/drawer');
      } else {
        showToast(
            message: register!,
            context: context,
            color: Colors.redAccent,
            isAlert: true);
      }
    }

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
                      "Find Property",
                      style: AppStyles.heading1.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Get Started",
                      style: AppStyles.heading3.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 450.w,
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
                          controller: name,
                          label: "Full Name",
                          hintText: 'Enter Full Name',
                          inputType: TextInputType.text,
                          icon: Icons.person_outlined,
                        ),
                        SizedBox(height: 6.w),
                        UnderlinedTextField(
                          controller: email,
                          label: "Email",
                          hintText: 'Enter Email',
                          inputType: TextInputType.emailAddress,
                          icon: Icons.email_outlined,
                        ),
                        SizedBox(height: 6.w),
                        UnderlinedTextField(
                          controller: password,
                          label: "Password",
                          hintText: 'Enter Password',
                          inputType: TextInputType.text,
                          obscureText: true,
                          prefixSvgPath: AppIcons.lock,
                        ),
                        SizedBox(height: 6.w),
                        UnderlinedTextField(
                          controller: confirmPassword,
                          label: "Confirm Password",
                          hintText: 'Confirm Password',
                          inputType: TextInputType.text,
                          obscureText: true,
                          prefixSvgPath: AppIcons.lock,
                        ),
                        SizedBox(height: 8.w),
                        DropdownButtonExample(
                          list: professions,
                          onSelected: (value) {
                            setState(() {
                              profession.text = value;
                            });
                          },
                          initial: professions[0],
                          label: 'Your Professions',
                          svgIcon: AppIcons.profession,
                        ),
                        const Spacer(),
                        CustomButton(
                          text: "Sign Up",
                          onPressed: () {
                            if (password.text != confirmPassword.text) {
                              showToast(
                                message: "Password does not match",
                                context: context,
                                isAlert: true,
                                color: Colors.redAccent,
                              );
                            }
                            onSignUp();
                          },
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
                        "Already have an Account?",
                        style: AppStyles.normalText.copyWith(
                          color: AppColors.backgroundColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: onSignIn,
                        child: Text(
                          "Sign In here",
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
