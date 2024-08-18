import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stargate/config/core.dart';

class CustomToast extends StatelessWidget {
  final String message;
  final Color? color;
  final bool? isAlert;

  const CustomToast({
    super.key,
    required this.message,
    this.color,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: color ?? AppColors.blue,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isAlert == true
              ? const SizedBox()
              : const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
          const SizedBox(
            width: 12.0,
          ),
          Flexible(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: AppStyles.heading3.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showToast({
  required String message,
  required BuildContext context,
  Color? color,
  bool? isAlert,
}) {
  FToast fToast = FToast();
  fToast.init(context);

  fToast.showToast(
    child: CustomToast(
      message: message,
      color: color,
      isAlert: isAlert,
    ),
    gravity: ToastGravity.BOTTOM,
    toastDuration: const Duration(seconds: 2),
  );
}
