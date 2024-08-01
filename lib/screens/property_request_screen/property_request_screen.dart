import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/screens/listings/widgets/dropdown_button2.dart';
import 'package:stargate/utils/app_data.dart';
import 'package:stargate/utils/app_images.dart';
import 'package:stargate/widgets/buttons/back_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/widgets/buttons/custom_button.dart';
import 'package:stargate/widgets/buttons/custom_tab_button.dart';
import 'package:stargate/widgets/inputfields/country_textfield.dart';
import 'package:stargate/widgets/inputfields/outlined_dropdown.dart';
import 'package:stargate/widgets/inputfields/textfield.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class PropertyRequestForm extends StatefulWidget {
  const PropertyRequestForm({super.key});

  @override
  State<PropertyRequestForm> createState() => _PropertyRequestFormState();
}

class _PropertyRequestFormState extends State<PropertyRequestForm> {
  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController equipment = TextEditingController();

  TextEditingController qualityOfEquipment = TextEditingController();
  TextEditingController numberOfParkingPlaces = TextEditingController();
  TextEditingController selectedLandArea = TextEditingController();
  TextEditingController selectedBuildingArea = TextEditingController();
  TextEditingController selectedBuildableArea = TextEditingController();
  TextEditingController parkingPlaces = TextEditingController();

  List<String> requestTypeList = ['offering', 'requesting'];
  String selectedRequestType = '';
  String selectedCondition = '';
  String selectedPurchaseType = '';
  String selectedPropertyType = '';

  String selectedInvestmentType = '';
  String selectedInvestmentSubcategory = '';
  int beds = 0;
  int bathroom = 0;
  int price = 0;
  String furnished = '';
  String garage = '';
  List<Uint8List> images = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: const CustomBackButton(
          color: AppColors.black,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 12.w, right: 12.w, left: 12.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Offer or Request\nProperty",
                style: AppStyles.screenTitle.copyWith(
                  color: AppColors.darkBlue,
                ),
              ),
              SizedBox(
                height: 16.w,
              ),
              CustomTextField(
                controller: title,
                label: "Title",
                hintText: "Title",
                inputType: TextInputType.text,
                horizontalSpacing: 0,
                verticalSpacing: 3,
              ),
              SizedBox(
                height: 3.w,
              ),
              CustomTextField(
                controller: address,
                label: "Address",
                hintText: "Address",
                inputType: TextInputType.text,
                horizontalSpacing: 0,
                verticalSpacing: 3,
              ),
              CountryPickerField(
                country: country,
                state: state,
                city: city,
              ),
              CustomTextField(
                controller: description,
                label: "Description",
                hintText: "Description",
                inputType: TextInputType.text,
                horizontalSpacing: 0,
                verticalSpacing: 3,
                maxLines: 4,
              ),
              SizedBox(
                height: 10.w,
              ),
              questionText(
                "Do you want to offer property or requesting for it?",
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...requestTypeList.map(
                      (e) => CustomTabButton(
                        type: e,
                        selected: (value) {
                          setState(() {
                            selectedRequestType = value;
                          });
                        },
                        current: selectedRequestType,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8.w,
              ),
              questionText(
                "Condition",
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...conditions.map(
                      (e) => CustomTabButton(
                        type: e,
                        selected: (value) {
                          setState(() {
                            selectedCondition = value;
                          });
                        },
                        current: selectedCondition,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8.w,
              ),
              questionText(
                "Purchase",
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...sellingTypes.map(
                      (e) => CustomTabButton(
                        type: e,
                        selected: (value) {
                          setState(() {
                            selectedPurchaseType = value;
                          });
                        },
                        current: selectedPurchaseType,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8.w,
              ),
              questionText(
                "Type",
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...propertyTypes.map(
                      (e) => CustomTabButton(
                        type: e,
                        selected: (value) {
                          setState(() {
                            selectedPropertyType = value;
                          });
                        },
                        current: selectedPropertyType,
                      ),
                    ),
                  ],
                ),
              ),
              selectedPropertyType == 'commercial'
                  ? commercialContent()
                  : selectedPropertyType == 'conventional'
                      ? conventionalContent()
                      : const SizedBox(),
              SizedBox(
                height: 20.w,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatPrice(double price) {
    final NumberFormat formatter = NumberFormat("###,###", "de_DE");
    String formattedPrice = formatter.format(price).replaceAll(',', ' ');
    return formattedPrice;
  }

  Widget questionText(String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 6.w),
      child: Text(
        text,
        style: AppStyles.normalText.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.darkBlue,
        ),
      ),
    );
  }

  Widget commercialContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        questionText(
          "Investment type",
        ),
        OutlinedDropdownButtonExample(
          list: commercialPropertyCategory,
          onSelected: (value) {
            setState(() {
              selectedInvestmentType = value;
            });
          },
          initial: commercialPropertyCategory[0],
          label: 'Investment Type',
        ),
        SizedBox(
          height: 8.w,
        ),
        questionText(
          "Investment subcategory",
        ),
        OutlinedDropdownButtonExample(
          list: commercialPropertySubcategory,
          onSelected: (value) {
            selectedInvestmentSubcategory = value;
          },
          initial: commercialPropertySubcategory[0],
          label: 'Investment subcategory',
        ),
        SizedBox(
          height: 6.w,
        ),
        CustomTextField(
          controller: selectedLandArea,
          label: "land area in m²",
          hintText: "land area in m²",
          inputType: TextInputType.number,
          horizontalSpacing: 0,
          verticalSpacing: 3,
        ),
        SizedBox(
          height: 3.w,
        ),
        CustomTextField(
          controller: selectedBuildingArea,
          label: "building usage area in m²",
          hintText: "building usage area in m²",
          inputType: TextInputType.number,
          horizontalSpacing: 0,
          verticalSpacing: 3,
        ),
        SizedBox(
          height: 3.w,
        ),
        CustomTextField(
          controller: selectedBuildableArea,
          label: "build able area in m²",
          hintText: "build able area in m²",
          inputType: TextInputType.number,
          horizontalSpacing: 0,
          verticalSpacing: 3,
        ),
        SizedBox(
          height: 10.w,
        ),
        sliderSelections(),
        SizedBox(
          height: 10.w,
        ),
        questionText("Furnished"),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...furnishedTypes.map(
                (e) => CustomTabButton(
                  type: e,
                  selected: (value) {
                    setState(() {
                      furnished = value;
                    });
                  },
                  current: furnished,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 3.w,
        ),
        CustomTextField(
          controller: equipment,
          label: "any equipments",
          hintText: "any equipments",
          inputType: TextInputType.text,
          horizontalSpacing: 0,
          verticalSpacing: 3,
        ),
        SizedBox(
          height: 3.w,
        ),
        CustomTextField(
          controller: qualityOfEquipment,
          label: "quality of equipments",
          hintText: "any equipments",
          inputType: TextInputType.text,
          horizontalSpacing: 0,
          verticalSpacing: 3,
        ),
        SizedBox(
          height: 3.w,
        ),
        CustomTextField(
          controller: parkingPlaces,
          label: "no of parking places",
          hintText: "no of parking places",
          inputType: TextInputType.number,
          horizontalSpacing: 0,
          verticalSpacing: 3,
        ),
        SizedBox(
          height: 10.w,
        ),
        questionText("Add pictures"),
        SizedBox(
          height: 6.w,
        ),
        Container(
          height: 100.w,
          width: 100.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.w),
            border: Border.all(
              width: 1,
              color: AppColors.lightGrey,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.add,
              color: AppColors.blue,
            ),
          ),
        ),
        SizedBox(
          height: 10.w,
        ),
        const CustomButton(
          text: "Post",
        ),
      ],
    );
  }

  Widget conventionalContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        questionText(
          "Investment type",
        ),
        DropdownButton2Example(
          list: conventionalPropertyCategory,
          onSelected: (value) {
            setState(() {
              selectedInvestmentType = value;
            });
          },
          initial: conventionalPropertyCategory[0],
          label: 'Investment Type',
        ),
        SizedBox(
          height: 8.w,
        ),
        questionText(
          "Investment subcategory",
        ),
        DropdownButton2Example(
          list: conventionalPropertySubcategory,
          onSelected: (value) {
            selectedInvestmentSubcategory = value;
          },
          initial: conventionalPropertySubcategory[0],
          label: 'Investment subcategory',
        ),
        SizedBox(
          height: 6.w,
        ),
        CustomTextField(
          controller: selectedLandArea,
          label: "land area in m²",
          hintText: "land area in m²",
          inputType: TextInputType.number,
          horizontalSpacing: 0,
          verticalSpacing: 3,
        ),
        SizedBox(
          height: 3.w,
        ),
        CustomTextField(
          controller: selectedBuildingArea,
          label: "building usage area in m²",
          hintText: "building usage area in m²",
          inputType: TextInputType.number,
          horizontalSpacing: 0,
          verticalSpacing: 3,
        ),
        SizedBox(
          height: 3.w,
        ),
        CustomTextField(
          controller: selectedBuildableArea,
          label: "build able area in m²",
          hintText: "build able area in m²",
          inputType: TextInputType.number,
          horizontalSpacing: 0,
          verticalSpacing: 3,
        ),
        SizedBox(
          height: 10.w,
        ),
        sliderSelections(),
        SizedBox(
          height: 10.w,
        ),
        questionText("Furnished"),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...furnishedTypes.map(
                (e) => CustomTabButton(
                  type: e,
                  selected: (value) {
                    setState(() {
                      furnished = value;
                    });
                  },
                  current: furnished,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.w,
        ),
        questionText("Garage"),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...furnishedTypes.map(
                (e) => CustomTabButton(
                  type: e,
                  selected: (value) {
                    setState(() {
                      garage = value;
                    });
                  },
                  current: garage,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.w,
        ),
        questionText("Add pictures"),
        SizedBox(
          height: 6.w,
        ),
        Container(
          height: 100.w,
          width: 100.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.w),
            border: Border.all(
              width: 1,
              color: AppColors.lightGrey,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.add,
              color: AppColors.blue,
            ),
          ),
        ),
        SizedBox(
          height: 10.w,
        ),
        const CustomButton(
          text: "Post",
        ),
      ],
    );
  }

  Widget sliderSelections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              AppImages.room,
              width: 28,
            ),
            SizedBox(
              width: 12.w,
            ),
            questionText("Rooms"),
            const Spacer(),
            Text(
              beds.toString(),
              style: AppStyles.heading4.copyWith(
                color: AppColors.blue,
              ),
            ),
            SizedBox(
              width: 6.w,
            ),
          ],
        ),
        SfSlider(
          min: 0.0,
          max: 50.0,
          value: beds,
          interval: 1.0,
          showLabels: false,
          enableTooltip: true,
          minorTicksPerInterval: 1,
          activeColor: AppColors.blue,
          inactiveColor: AppColors.lightGrey,
          tooltipShape: const SfPaddleTooltipShape(),
          onChanged: (value) {
            setState(() {
              beds = value.toInt();
            });
          },
        ),
        SizedBox(
          height: 6.w,
        ),
        Row(
          children: [
            Image.asset(
              AppImages.bath,
            ),
            SizedBox(
              width: 12.w,
            ),
            questionText("Bathrooms"),
            const Spacer(),
            Text(
              bathroom.toString(),
              style: AppStyles.heading4.copyWith(
                color: AppColors.blue,
              ),
            ),
            SizedBox(
              width: 6.w,
            ),
          ],
        ),
        SfSlider(
          min: 0.0,
          max: 50.0,
          value: bathroom,
          interval: 1.0,
          showLabels: false,
          enableTooltip: true,
          minorTicksPerInterval: 1,
          activeColor: AppColors.blue,
          inactiveColor: AppColors.lightGrey,
          tooltipShape: const SfPaddleTooltipShape(),
          onChanged: (value) {
            setState(() {
              bathroom = value.toInt();
            });
          },
        ),
        Row(
          children: [
            Image.asset(
              AppIcons.cash,
              width: 32,
            ),
            SizedBox(
              width: 12.w,
            ),
            questionText("Price"),
            const Spacer(),
            Text(
              "€ ${formatPrice(price.toDouble())}",
              style: AppStyles.heading4.copyWith(
                color: AppColors.blue,
              ),
            ),
            SizedBox(
              width: 6.w,
            ),
          ],
        ),
        SfSlider(
          min: 0.0,
          max: 100000000.0,
          value: price,
          interval: 100000.0,
          showLabels: false,
          enableTooltip: true,
          minorTicksPerInterval: 1000,
          activeColor: AppColors.blue,
          inactiveColor: AppColors.lightGrey,
          tooltipShape: const SfPaddleTooltipShape(),
          numberFormat:
              NumberFormat.simpleCurrency(locale: 'de_DE', decimalDigits: 0),
          onChanged: (value) {
            setState(() {
              price = value.toInt();
            });
          },
        ),
      ],
    );
  }
}
