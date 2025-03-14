import 'package:flutter/material.dart';
import 'package:country_picker_plus/country_picker_plus.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/localization/translation_strings.dart';
import '../../localization/localization.dart';

class CountryPickerField extends StatefulWidget {
  final TextEditingController country;
  TextEditingController city;
  TextEditingController state; // Add the form key here

  CountryPickerField({
    super.key,
    required this.country,
    required this.city,
    required this.state,
  });

  @override
  _CountryPickerFieldState createState() => _CountryPickerFieldState();
}

class _CountryPickerFieldState extends State<CountryPickerField> {
  final GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    // Fetch translations
    final selectCountryText =
        AppLocalization.of(context)!.translate(TranslationString.selectCountry);
    final selectStateText =
        AppLocalization.of(context)!.translate(TranslationString.selectState);
    final selectCityText =
        AppLocalization.of(context)!.translate(TranslationString.selectCity);

    var fieldDecoration = CPPFDecoration(
      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      margin: const EdgeInsets.symmetric(vertical: 4),
      suffixColor: AppColors.blue, // You can customize the suffix color
      innerColor: AppColors.blue.withOpacity(0.06),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.blue),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.primaryGrey.withOpacity(0.2)),
      ),
    );

    final bottomSheetDecoration = CPPBSHDecoration(
      closeColor: AppColors.blue,
      itemDecoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.03),
        borderRadius: BorderRadius.circular(8),
      ),
      itemsPadding: const EdgeInsets.all(8),
      itemsSpace: const EdgeInsets.symmetric(vertical: 4),
      itemTextStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );

    final searchDecoration = CPPSFDecoration(
      height: 45,
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      filled: true,
      margin: const EdgeInsets.symmetric(vertical: 8),
      hintStyle:
          const TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
      searchIconColor: Colors.white,
      textStyle: const TextStyle(color: Colors.white, fontSize: 12),
      innerColor: AppColors.lightBlue,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Form(
        key: formKey, // Using the form key from the parent widget
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CountryPickerPlus(
              isRequired: true,
              countryLabel: selectCountryText,
              countrySearchHintText: selectCountryText,
              countryHintText: selectCountryText,
              stateHintText: selectStateText,
              stateLabel: selectStateText,
              cityHintText: selectCityText,
              cityLabel: selectCityText,
              bottomSheetDecoration: bottomSheetDecoration,
              decoration: fieldDecoration,
              searchDecoration: searchDecoration,
              onCountrySaved: (value) {
                widget.country.text = value.toString();
              },
              onCitySaved: (value) {
                widget.city.text = value.toString();
              },
              onStateSaved: (value) {
                widget.state.text = value.toString();
              },
              onCountrySelected: (value) {
                setState(() {
                  widget.country.text = value.toString();
                  widget.state.clear(); // Clear text properly
                  widget.city.clear();
                });
              },
              onStateSelected: (value) {
                setState(() {
                  widget.state.text = value.toString();
                  widget.city.clear();
                  widget.city.text = '';
                });
              },
              onCitySelected: (value) {
                setState(() {
                  widget.city.text = value.toString();
                });
              },
            ),
            // Add a custom validation for the form
          ],
        ),
      ),
    );
  }
}
