// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/services/user_profiling.dart';
import 'package:stargate/utils/app_images.dart';
import 'package:stargate/widgets/buttons/back_button.dart';
import 'package:stargate/widgets/buttons/custom_button.dart';
import 'package:stargate/widgets/custom_toast.dart';
import 'package:stargate/widgets/loader/loader.dart';
import 'package:stargate/widgets/screen/screen.dart';

import '../../widgets/inputfields/textfield.dart';

// ignore: must_be_immutable
class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool loading = false;

  TextEditingController oldPassword = TextEditingController();

  TextEditingController newPassword = TextEditingController();

  TextEditingController confirmPassword = TextEditingController();

  void changePass() async {
    if (newPassword.text != confirmPassword.text) {
      showToast(
        message: "Password does not match",
        context: context,
        isAlert: true,
        color: Colors.redAccent,
      );
    } else {
      setState(() {
        loading = true;
      });
      try {
        String result =
            await changePassword(oldPassword.text, newPassword.text);
        if (result == 'Password Changed Successfully!') {
          showToast(message: result, context: context);
          setState(() {
            loading = false;
          });
          Navigator.pop(context);
        } else {
          showToast(message: result, context: context);
          setState(() {
            loading = false;
          });
        }
      } catch (e) {
        //
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      overlayWidgets: [
        if (loading)
          const FullScreenLoader(
            loading: true,
          ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          leading: const CustomBackButton(),
          title: Text(
            "Change Password",
            style: AppStyles.heading3.copyWith(color: AppColors.darkBlue),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(
            12.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 3.w,
              ),
              CustomTextField(
                controller: oldPassword,
                label: "Current Password",
                hintText: "Current Password",
                inputType: TextInputType.text,
                verticalSpacing: 3.w,
                horizontalSpacing: 0,
                prefixSvgPath: AppIcons.lock,
                isPasswordField: true,
              ),
              SizedBox(
                height: 3.w,
              ),
              CustomTextField(
                controller: newPassword,
                label: "New Password",
                hintText: "New Password",
                inputType: TextInputType.text,
                verticalSpacing: 3.w,
                horizontalSpacing: 0,
                prefixSvgPath: AppIcons.lock,
                isPasswordField: true,
              ),
              SizedBox(
                height: 3.w,
              ),
              CustomTextField(
                controller: confirmPassword,
                label: "Confirm Password",
                hintText: "Confirm Password",
                inputType: TextInputType.text,
                verticalSpacing: 3.w,
                horizontalSpacing: 0,
                prefixSvgPath: AppIcons.lock,
                obscureText: true,
                isPasswordField: true,
              ),
              SizedBox(
                height: 24.w,
              ),
              GestureDetector(
                onTap: changePass,
                child: const CustomButton(text: "Change Password"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
