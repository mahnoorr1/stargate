import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stargate/config/core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UnderlinedTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final String? prefixSvgPath;
  final IconData? icon;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final TextInputType inputType;

  const UnderlinedTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.prefixSvgPath,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    required this.inputType,
    this.icon,
  });

  @override
  State<UnderlinedTextField> createState() => _UnderlinedTextFieldState();
}

class _UnderlinedTextFieldState extends State<UnderlinedTextField> {
  late FocusNode _focusNode;
  // ignore: unused_field
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      enabled: true,
      controller: widget.controller,
      textCapitalization: widget.textCapitalization,
      maxLength: 32,
      maxLines: 1,
      obscureText: widget.obscureText,
      keyboardType: widget.inputType,
      textAlign: TextAlign.start,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      cursorColor: AppColors.blue,
      decoration: InputDecoration(
        focusColor: AppColors.blue,
        prefixIcon: widget.prefixSvgPath != null
            ? Padding(
                padding: EdgeInsets.only(top: 18.w, bottom: 10.w),
                child: SvgPicture.asset(
                  widget.prefixSvgPath!,
                  // ignore: deprecated_member_use
                  color: AppColors.white,
                ),
              )
            : Padding(
                padding: EdgeInsets.only(top: 12.w),
                child: Icon(
                  widget.icon,
                  color: AppColors.white,
                ),
              ),
        isDense: false,
        label: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            widget.label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          ),
        ),
        counterText: "",
        hintText: widget.hintText,
        hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: AppColors.lightGrey),
        labelStyle: const TextStyle(color: AppColors.white),
        contentPadding: const EdgeInsets.all(10),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryGrey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.white),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.lightGrey),
        ),
      ),
    );
  }
}
