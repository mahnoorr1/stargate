import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AppColors {
  static const black = Color.fromARGB(255, 1, 23, 43);
  static const primaryGrey = Color(0xFF959494);
  static const darkGrey = Color(0xFF707070);
  static const lightGrey = Color.fromARGB(255, 235, 235, 235);
  static const blue = Color(0xFF0075C2);
  static const darkBlue = Color(0xFF003B74);
  static const lightBlue = Color.fromRGBO(206, 220, 240, 0.5);
  static const white = Colors.white;
  static const backgroundColor = Color.fromARGB(255, 246, 247, 249);
}

void easyLoading() {
  EasyLoading.show(
    indicator: const CircularProgressIndicator(
      backgroundColor: Colors.white,
      color: Colors.teal,
    ),
    maskType: EasyLoadingMaskType.none,
    dismissOnTap: true,
  );
}

class AppStyles {
  static const screenTitle = TextStyle(
    color: AppColors.black,
    fontWeight: FontWeight.w600,
    fontSize: 24,
  );
  static const heading1 = TextStyle(
    color: AppColors.darkBlue,
    fontWeight: FontWeight.bold,
    fontSize: 32,
  );
  static const heading2 = TextStyle(
    color: AppColors.darkBlue,
    fontWeight: FontWeight.w600,
    fontSize: 24,
  );
  static const heading3 = TextStyle(
    color: AppColors.black,
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );
  static const heading4 = TextStyle(
    color: AppColors.black,
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );
  static const normalText = TextStyle(
    color: AppColors.black,
    fontSize: 14,
  );
  static const greyText = TextStyle(
    color: AppColors.primaryGrey,
    fontSize: 14,
  );
  static const supportiveText = TextStyle(
    color: AppColors.primaryGrey,
    fontSize: 12,
  );
  static BoxShadow boxShadow = BoxShadow(
    // ignore: deprecated_member_use
    color: AppColors.black.withOpacity(0.01),
    spreadRadius: 5,
    blurRadius: 1,
    offset: const Offset(0, 0),
  );
}

class GlobalVariables {
  static const server = 'http://localhost:3000/api/v1/';
}
