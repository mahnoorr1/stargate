// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:stargate/config/core.dart';

class CountryPickerField extends StatefulWidget {
  final TextEditingController country;
  final TextEditingController city;
  final TextEditingController state;

  const CountryPickerField({
    super.key,
    required this.country,
    required this.city,
    required this.state,
  });

  @override
  _CountryPickerFieldState createState() => _CountryPickerFieldState();
}

class _CountryPickerFieldState extends State<CountryPickerField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CountryStateCityPicker(
            country: widget.country,
            state: widget.state,
            city: widget.city,
            dialogColor: Colors.grey.shade200,
            textFieldDecoration: const InputDecoration(
              fillColor: AppColors.white,
              filled: true,
              labelStyle: TextStyle(color: AppColors.primaryGrey),
              suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.lightGrey),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.blue),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.lightGrey),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
