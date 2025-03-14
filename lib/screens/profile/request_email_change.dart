import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stargate/config/constants.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/localization/localization.dart';
import 'package:stargate/localization/translation_strings.dart';
import 'package:stargate/providers/user_info_provider.dart';
import 'package:stargate/widgets/buttons/custom_button.dart';
import 'package:stargate/widgets/custom_toast.dart';
import 'package:stargate/widgets/inputfields/textfield.dart';
import 'package:stargate/widgets/loader/loader.dart';
import 'package:stargate/widgets/screen/screen.dart';
import 'package:stargate/widgets/translationWidget.dart';

class EmailChangeScreen extends StatefulWidget {
  const EmailChangeScreen({super.key});

  @override
  State<EmailChangeScreen> createState() => _EmailChangeScreenState();
}

class _EmailChangeScreenState extends State<EmailChangeScreen> {
  bool otpVerified = false;
  bool otpSent = false;
  bool emailChangeSuccess = false;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController otp = TextEditingController();
  final RegExp emailRegex =
      RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

  bool isValidEmail(String email) {
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: translationWidget(
          "Change Email",
          context,
          "Change Email",
          AppStyles.heading2,
        ),
        centerTitle: true,
      ),
      body: Screen(
        overlayWidgets: [
          if (loading)
            const FullScreenLoader(
              loading: true,
            ),
        ],
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50.w,
                ),
                otpSent
                    ? const SizedBox()
                    : Text(AppLocalization.of(context)!
                        .translate(TranslationString.email)),
                otpSent
                    ? const SizedBox()
                    : CustomTextField(
                        controller: email,
                        label: AppLocalization.of(context)!
                            .translate(TranslationString.enterEmail),
                        hintText: AppLocalization.of(context)!
                            .translate(TranslationString.email),
                        inputType: TextInputType.text,
                        horizontalSpacing: 1,
                        verticalSpacing: 6,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !isValidEmail(value)) {
                            return AppLocalization.of(context)!.translate(
                                TranslationString
                                    .pleaseEnterValidEmail); // Error message
                          }
                          return null;
                        },
                      ),
                SizedBox(
                  height: 20.w,
                ),
                otpSent
                    ? CustomTextField(
                        controller: otp,
                        label: AppLocalization.of(context)!
                            .translate(TranslationString.enterOTP),
                        hintText: AppLocalization.of(context)!
                            .translate(TranslationString.enterOTP),
                        inputType: TextInputType.number,
                        horizontalSpacing: 3,
                        verticalSpacing: 6,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalization.of(context)!.translate(
                                TranslationString
                                    .input6DigitsOtp); // Error message
                          }
                          return null;
                        },
                      )
                    : const SizedBox(),
                SizedBox(
                  height: 40.w,
                ),
                GestureDetector(
                  onTap: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    } else if (otpSent) {
                      Map<String, String> response =
                          await verifyEmailChange(otp: otp.text);
                    } else {
                      Map<String, String> response =
                          await requestEmailChange(newEmail: email.text);
                    }
                  },
                  child: CustomButton(
                    text: !otpSent
                        ? AppLocalization.of(context)!
                            .translate(TranslationString.verifyOTP)
                        : AppLocalization.of(context)!
                            .translate(TranslationString.update),
                  ),
                ),
                SizedBox(
                  height: 12.w,
                ),
                otpSent
                    ? Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () async {
                            Map<String, String> response =
                                await resendEmailVerification();
                          },
                          child: Text(
                            AppLocalization.of(context)!
                                .translate(TranslationString.resendOtp),
                            style: AppStyles.heading4.copyWith(
                              color: AppColors.blue,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Map<String, String>> requestEmailChange({
    required String newEmail,
  }) async {
    var url = Uri.parse('${server}user/request-email-change');
    if (newEmail == UserProfileProvider.c(context).email) {
      showToast(
          message: AppLocalization.of(context)!.translate(
            TranslationString.emailAlreadyInYourUse,
          ),
          context: context,
          color: Colors.redAccent);
      return {};
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token!,
    };

    var body = json.encode({
      "newEmail": newEmail,
    });
    setState(() {
      loading = true;
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print("otp sent");
        var data = json.decode(response.body);
        print(data);
        setState(() {
          loading = false;
          otpSent = true;
        });

        showToast(
          message: data['message'],
          context: context,
        );
        return data;
      } else {
        var data = json.decode(response.body);
        setState(() {
          loading = false;
        });
        showToast(
            message: data['message'],
            context: context,
            color: Colors.redAccent);
        return data as Map<String, String>;
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      return {'error': "Unable to process request"};
    }
  }

  Future<Map<String, String>> verifyEmailChange({
    required String otp,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');
    var url = Uri.parse('${server}user/verify-email-change');

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    setState(() {
      loading = true;
    });

    var body = json.encode({
      "otp": otp,
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print("otp verified");
        var data = json.decode(response.body);
        print(data);

        UserProfileProvider.c(context).setEmail(email.text);
        setState(() {});
        setState(() {
          loading = false;
        });

        showToast(
          message: data['message'],
          context: context,
        );
        Navigator.pop(context);
        return data;
      } else {
        var data = json.decode(response.body);
        setState(() {
          loading = false;
        });

        showToast(
            message: data['message'],
            context: context,
            color: Colors.redAccent);
        return data as Map<String, String>;
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      return {'error': "Unable to process request"};
    }
  }

  Future<Map<String, String>> resendEmailVerification() async {
    var url = Uri.parse('${server}user/resend-email-verification');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');
    var headers = {
      'Authorization': 'Bearer $token',
    };
    setState(() {
      loading = true;
    });

    try {
      var response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        print("otp resend");
        var data = json.decode(response.body);
        print(data);
        setState(() {
          loading = false;
        });
        showToast(
          message: data['message'],
          context: context,
        );
        return data;
      } else {
        var data = json.decode(response.body);
        setState(() {
          loading = false;
        });
        showToast(
            message: data['message'],
            context: context,
            color: Colors.redAccent);
        return data as Map<String, String>;
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      return {'error': "Unable to process request"};
    }
  }
}
