import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stargate/config/core.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final String? prefixSvgPath;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final TextInputType inputType;
  final double? horizontalSpacing;
  final double? verticalSpacing;
  final int maxLines;
  final bool isPasswordField;
  final Function(dynamic value)? onChanged;
  final FormFieldValidator<String>? validator; // Add validator

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.prefixSvgPath,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    required this.inputType,
    this.isPasswordField = false,
    this.horizontalSpacing,
    this.verticalSpacing,
    this.maxLines = 1,
    this.onChanged,
    this.validator, // Accept validator
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);

    _obscureText = widget.obscureText;
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

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: widget.horizontalSpacing ?? 20,
          vertical: widget.verticalSpacing ?? 7),
      child: TextFormField(
        onChanged: (value) {
          widget.onChanged!(value);
        },
        focusNode: _focusNode,
        enabled: true,
        controller: widget.controller,
        textCapitalization: widget.textCapitalization,
        maxLength: widget.maxLines == 1 ? 32 : null,
        maxLines: widget.maxLines,
        obscureText: widget.obscureText,
        keyboardType: widget.inputType,
        textAlign: TextAlign.start,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
        cursorColor: AppColors.blue,
        decoration: InputDecoration(
          focusColor: AppColors.blue,
          prefixIcon: widget.prefixSvgPath != null
              ? Padding(
                  padding: const EdgeInsets.all(15),
                  child: SvgPicture.asset(
                    widget.prefixSvgPath!,
                    width: 17,
                    height: 17,
                    color: _isFocused ? AppColors.blue : AppColors.lightGrey,
                  ),
                )
              : null,
          isDense: false,
          label: Text(
            widget.label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          ),
          counterText: "",
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: AppColors.primaryGrey,
          ),
          alignLabelWithHint: true,
          labelStyle: const TextStyle(color: AppColors.primaryGrey),
          contentPadding: const EdgeInsets.all(18),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.lightGrey),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.blue),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.lightGrey),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          suffixIcon: widget.isPasswordField
              ? IconButton(
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.remove_red_eye_outlined,
                    color: AppColors.lightGrey,
                  ),
                  onPressed: _togglePasswordVisibility,
                )
              : null,
        ),
        validator: widget.validator, // Use the validator
      ),
    );
  }
}
