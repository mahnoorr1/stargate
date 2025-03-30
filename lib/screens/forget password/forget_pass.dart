// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/services/user_profiling.dart';
import 'package:stargate/widgets/buttons/back_button.dart';
import 'package:stargate/widgets/custom_toast.dart';
import 'package:stargate/widgets/inputfields/underlined_textfield.dart';
import 'package:stargate/widgets/loader/loader.dart';
import 'package:stargate/widgets/screen/screen.dart';

import '../../config/core.dart';
import '../../localization/localization.dart';
import '../../localization/translation_strings.dart';
import '../../utils/app_images.dart';
import '../../widgets/buttons/custom_button.dart';

class ForgetPass extends StatefulWidget {
  const ForgetPass({super.key});

  @override
  State<ForgetPass> createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  TextEditingController email = TextEditingController();

  TextEditingController otp = TextEditingController();

  TextEditingController pass = TextEditingController();

  TextEditingController confirmPass = TextEditingController();

  bool loading = false;

  final formKey = GlobalKey<FormState>();

  bool emailActive = true;

  bool otpActive = false;

  bool changePass = false;

  void onEmailContinue() async {
    if (email.text.isEmpty) {
      showToast(
        message: AppLocalization.of(context)!
            .translate(TranslationString.pleaseEnterEmail),
        context: context,
        isAlert: true,
        color: Colors.redAccent,
      );
    } else {
      setState(() {
        loading = true;
      });
      String emailResponse = await forgetPassword(email.text);
      showToast(
        message: emailResponse,
        context: context,
      );
      if (emailResponse == 'OTP sent to your email') {
        setState(() {
          emailActive = false;
          otpActive = true;
          loading = false;
        });
      }
      setState(() {
        loading = false;
      });
    }
  }

  void verifyOTP() async {
    setState(() {
      loading = true;
    });
    String response = await verifyForgetPassOTP(otp.text, email.text);
    showToast(message: response, context: context, isAlert: true);
    setState(() {
      loading = false;
    });
    if (response == 'Email verified!') {
      setState(() {
        otpActive = false;
        changePass = true;
      });
    }
  }

  void changePassword() async {
    if (pass.text != confirmPass.text) {
      showToast(
        message: AppLocalization.of(context)!
            .translate(TranslationString.passwordDoesNotMatch),
        context: context,
        isAlert: true,
        color: Colors.redAccent,
      );
    } else {
      setState(() {
        loading = true;
      });
      String response = await resetForgottenPassword(email.text, pass.text);
      showToast(message: response, context: context, isAlert: true);
      if (response == "Password Changed, Login to Continue!") {
        Navigator.pop(context);
      }
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      overlayWidgets: [
        if (loading)
          const FullScreenLoader(
            loading: true,
          )
      ],
      child: Scaffold(
        body: Container(
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
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 60.w, horizontal: 10.w),
                  child: const CustomBackButton(
                    color: Colors.white,
                  ),
                ),
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
                        SizedBox(
                          height: 70.h,
                        ),
                        Text(
                          emailActive
                              ? AppLocalization.of(context)!
                                  .translate(TranslationString.forgotPassword)
                              : otpActive
                                  ? AppLocalization.of(context)!
                                      .translate(TranslationString.verifyOTP)
                                  : AppLocalization.of(context)!
                                      .translate(TranslationString.changePass),
                          style: AppStyles.heading1.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          emailActive
                              ? AppLocalization.of(context)!.translate(
                                  TranslationString.verifyEmailToContinue)
                              : otpActive
                                  ? "${AppLocalization.of(context)!.translate(TranslationString.enterOTPSentToYouAt)} ${email.text}"
                                  : AppLocalization.of(context)!.translate(
                                      TranslationString.enterNewPassword),
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
                              emailActive
                                  ? UnderlinedTextField(
                                      controller: email,
                                      label: AppLocalization.of(context)!
                                          .translate(TranslationString.email),
                                      hintText: AppLocalization.of(context)!
                                          .translate(
                                              TranslationString.enterEmail),
                                      inputType: TextInputType.emailAddress,
                                      icon: Icons.email_outlined,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return AppLocalization.of(context)!
                                              .translate(TranslationString
                                                  .pleaseEnterEmail);
                                        }
                                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                            .hasMatch(value)) {
                                          return AppLocalization.of(context)!
                                              .translate(TranslationString
                                                  .pleaseEnterValidEmail);
                                        }
                                        return null;
                                      },
                                    )
                                  : otpActive
                                      ? UnderlinedTextField(
                                          controller: otp,
                                          label: AppLocalization.of(context)!
                                              .translate(
                                                  TranslationString.enterOTP),
                                          hintText: AppLocalization.of(context)!
                                              .translate(
                                                  TranslationString.enterOTP),
                                          inputType: TextInputType.number,
                                          icon: Icons.password,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return AppLocalization.of(
                                                      context)!
                                                  .translate(TranslationString
                                                      .pleaseEnterOTP);
                                            }

                                            return null;
                                          },
                                        )
                                      : Column(
                                          children: [
                                            UnderlinedTextField(
                                              controller: pass,
                                              label:
                                                  AppLocalization.of(context)!
                                                      .translate(
                                                          TranslationString
                                                              .newPassword),
                                              hintText:
                                                  AppLocalization.of(context)!
                                                      .translate(
                                                          TranslationString
                                                              .newPassword),
                                              inputType: TextInputType.text,
                                              prefixSvgPath: AppIcons.lock,
                                              obscureText: true,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return AppLocalization.of(
                                                          context)!
                                                      .translate(
                                                          TranslationString
                                                              .pleaseEnterPass);
                                                } else if (value.length < 8) {
                                                  return AppLocalization.of(
                                                          context)!
                                                      .translate(TranslationString
                                                          .passwordShouldBe8Characters);
                                                }

                                                return null;
                                              },
                                            ),
                                            SizedBox(
                                              height: 3.w,
                                            ),
                                            UnderlinedTextField(
                                              controller: confirmPass,
                                              label:
                                                  AppLocalization.of(context)!
                                                      .translate(
                                                          TranslationString
                                                              .confirmPass),
                                              hintText:
                                                  AppLocalization.of(context)!
                                                      .translate(
                                                          TranslationString
                                                              .confirmPass),
                                              inputType: TextInputType.text,
                                              prefixSvgPath: AppIcons.lock,
                                              obscureText: true,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return AppLocalization.of(
                                                          context)!
                                                      .translate(
                                                          TranslationString
                                                              .pleaseEnterPass);
                                                } else if (value.length < 8) {
                                                  return AppLocalization.of(
                                                          context)!
                                                      .translate(TranslationString
                                                          .passwordShouldBe8Characters);
                                                }

                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                              const Spacer(),
                              CustomButton(
                                  text: changePass
                                      ? AppLocalization.of(context)!.translate(
                                          TranslationString.changePass)
                                      : AppLocalization.of(context)!.translate(
                                          TranslationString.continueText),
                                  onPressed: () {
                                    if (emailActive) {
                                      if (formKey.currentState!.validate()) {
                                        onEmailContinue();
                                      }
                                    } else if (otpActive) {
                                      if (formKey.currentState!.validate()) {
                                        verifyOTP();
                                      }
                                    } else {
                                      if (formKey.currentState!.validate()) {
                                        changePassword();
                                      }
                                    }
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
