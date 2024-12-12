// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/localization/translation_strings.dart';

import '../../localization/localization.dart';

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
    // Fetch translations
    final selectCountryText =
        AppLocalization.of(context)!.translate(TranslationString.selectCountry);
    final selectStateText =
        AppLocalization.of(context)!.translate(TranslationString.selectState);
    final selectCityText =
        AppLocalization.of(context)!.translate(TranslationString.selectCity);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CountryStateCityPicker(
            country: widget.country,
            state: widget.state,
            city: widget.city,
            dialogColor: Colors.grey.shade200,
            textFieldDecoration: InputDecoration(
              fillColor: AppColors.white,
              filled: true,
              // Dynamically update hintText based on the field
              hintText: widget.country.text.isEmpty
                  ? selectCountryText
                  : widget.state.text.isEmpty
                      ? selectStateText
                      : widget.city.text.isEmpty
                          ? selectCityText
                          : null,
              hintStyle: const TextStyle(
                color: AppColors.primaryGrey,
                fontSize: 14,
              ),
              labelStyle: const TextStyle(
                color: AppColors.primaryGrey,
                fontSize: 14,
              ),
              suffixIcon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.primaryGrey,
              ),
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
            ),
          ),
        ],
      ),
    );
  }
}
