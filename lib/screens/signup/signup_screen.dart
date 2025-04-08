// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/screens/otp_screen/otp_Screen.dart';
import 'package:stargate/services/user_profiling.dart';
import 'package:stargate/utils/app_data.dart';
import 'package:stargate/utils/app_images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/widgets/buttons/custom_button.dart';
import 'package:stargate/widgets/custom_toast.dart';
import 'package:stargate/widgets/inputfields/dropdown.dart';
import 'package:stargate/widgets/inputfields/service_dropdown_underlined.dart';
import 'package:stargate/widgets/inputfields/underlined_textfield.dart';
import 'package:stargate/widgets/loader/loader.dart';
import 'package:stargate/widgets/screen/screen.dart';

import '../../localization/language_toggle_button.dart';
import '../../localization/localization.dart';
import '../../localization/translation_strings.dart';
import '../../utils/app_enums.dart';

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
  bool loading = false;

  List<String> professions = [];

  bool registerSuccess = false;

  void onSignIn() {
    Navigator.popAndPushNamed(context, '/login');
  }

  bool isValidEmail() {
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
    return emailRegex.hasMatch(email.text);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    professions = [
      UserType.agent.toCamelCaseString(),
      UserType.investor.toCamelCaseString(),
      UserType.consultant.toCamelCaseString(),
      UserType.lawyer.toCamelCaseString(),
      UserType.notary.toCamelCaseString(),
      UserType.appraiser.toCamelCaseString(),
      UserType.manager.toCamelCaseString(),
      UserType.loanBroker.toCamelCaseString(),
      UserType.economist.toCamelCaseString(),
      UserType.drawingMaker.toCamelCaseString(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    void onSignUp() async {
      setState(() {
        loading = true;
      });
      if (name.text.isEmpty ||
          email.text.isEmpty ||
          password.text.isEmpty ||
          confirmPassword.text.isEmpty ||
          profession.text ==
              AppLocalization.of(context)!
                  .translate(TranslationString.selectProfession)) {
        setState(() {
          loading = false;
        });
        showToast(
          message: AppLocalization.of(context)!
              .translate(TranslationString.pleaseEnterAllFields),
          context: context,
          isAlert: true,
          color: Colors.redAccent,
        );
      } else if (!isValidEmail()) {
        setState(() {
          loading = false;
        });
        showToast(
          message: AppLocalization.of(context)!
              .translate(TranslationString.invalidEmail),
          context: context,
          isAlert: true,
          color: Colors.redAccent,
        );
      } else if (password.text != confirmPassword.text) {
        setState(() {
          loading = false;
        });
        showToast(
          message: AppLocalization.of(context)!
              .translate(TranslationString.passwordDoesNotMatch),
          context: context,
          isAlert: true,
          color: Colors.redAccent,
        );
      } else {
        String? register = await registerUser(
            name.text, email.text, password.text, profession.text);
        if (register ==
            'User registered successfully. Please check your email for the OTP.') {
          registerSuccess = true;
          setState(() {
            loading = false;
          });
          showToast(
              message: AppLocalization.of(context)!.translate(
                  TranslationString.userRegisteredSuccessfullyPleaseEnterOtp),
              context: context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPScreen(
                email: email.text,
                password: password.text,
              ),
            ),
          );
        } else {
          setState(() {
            loading = false;
          });
          showToast(
              message: register!,
              context: context,
              color: Colors.redAccent,
              isAlert: true);
        }
      }
    }

    return Screen(
      overlayWidgets: [
        if (loading)
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: 60.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalization.of(context)!
                              .translate(TranslationString.offerOrFindPoperty),
                          style: AppStyles.heading1.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          AppLocalization.of(context)!
                              .translate(TranslationString.getStarted),
                          style: AppStyles.heading3.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.w),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 480.w,
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
                              label: AppLocalization.of(context)!
                                  .translate(TranslationString.enterFullName),
                              hintText: AppLocalization.of(context)!
                                  .translate(TranslationString.enterFullName),
                              inputType: TextInputType.text,
                              icon: Icons.person_outlined,
                            ),
                            SizedBox(height: 6.w),
                            UnderlinedTextField(
                              controller: email,
                              label: AppLocalization.of(context)!
                                  .translate(TranslationString.enterEmail),
                              hintText: AppLocalization.of(context)!
                                  .translate(TranslationString.enterEmail),
                              inputType: TextInputType.emailAddress,
                              icon: Icons.email_outlined,
                            ),
                            SizedBox(height: 6.w),
                            UnderlinedTextField(
                              controller: password,
                              label: AppLocalization.of(context)!
                                  .translate(TranslationString.enterPass),
                              hintText: AppLocalization.of(context)!
                                  .translate(TranslationString.enterPass),
                              inputType: TextInputType.text,
                              obscureText: true,
                              prefixSvgPath: AppIcons.lock,
                            ),
                            SizedBox(height: 6.w),
                            UnderlinedTextField(
                              controller: confirmPassword,
                              label: AppLocalization.of(context)!
                                  .translate(TranslationString.confirmPass),
                              hintText: AppLocalization.of(context)!
                                  .translate(TranslationString.confirmPass),
                              inputType: TextInputType.text,
                              obscureText: true,
                              prefixSvgPath: AppIcons.lock,
                            ),
                            SizedBox(height: 12.w),
                            Text(
                              AppLocalization.of(context)!.translate(
                                  TranslationString.selectProfession),
                              style: AppStyles.normalText.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            ServicesDropdownUnderlined(
                              list: servicesList,
                              onSelected: (value) {
                                setState(() {
                                  profession.text = value;
                                });
                              },
                              initial: servicesList[0],
                              label: AppLocalization.of(context)!
                                  .translate(TranslationString.yourProfession),
                              svgIcon: AppIcons.profession,
                            ),
                            const Spacer(),
                            CustomButton(
                              text: AppLocalization.of(context)!
                                  .translate(TranslationString.signUp),
                              onPressed: () {
                                if (password.text != confirmPassword.text) {
                                  showToast(
                                    message: AppLocalization.of(context)!
                                        .translate(TranslationString
                                            .passwordDoesNotMatch),
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
                    SizedBox(height: 20.w),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalization.of(context)!.translate(
                                TranslationString.alreadyHaveAccount),
                            style: AppStyles.normalText.copyWith(
                              color: AppColors.backgroundColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: onSignIn,
                            child: Text(
                              AppLocalization.of(context)!
                                  .translate(TranslationString.signInHere),
                              style: AppStyles.heading3.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.w),
                    const LanguageToggleButton(
                      isHorizontal: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
