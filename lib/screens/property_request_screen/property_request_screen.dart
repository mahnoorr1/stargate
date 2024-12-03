// ignore_for_file: unnecessary_nullable_for_final_variable_declarations, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/content_management/providers/offer_request_property_content_provider.dart';
import 'package:stargate/providers/real_estate_provider.dart';
import 'package:stargate/screens/listings/widgets/dropdown_button2.dart';
import 'package:stargate/utils/app_data.dart';
import 'package:stargate/utils/app_images.dart';
import 'package:stargate/widgets/buttons/back_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/widgets/buttons/custom_button.dart';
import 'package:stargate/widgets/buttons/custom_tab_button.dart';
import 'package:stargate/widgets/custom_toast.dart';
import 'package:stargate/widgets/inputfields/country_textfield.dart';
import 'package:stargate/widgets/inputfields/outlined_dropdown.dart';
import 'package:stargate/widgets/inputfields/textfield.dart';
import 'package:stargate/widgets/loader/loader.dart';
import 'package:stargate/widgets/screen/screen.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../services/helper_methods.dart';

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
  TextEditingController parkingPlaces = TextEditingController(text: '0');

  List<String> requestTypeList = ['offering', 'requesting'];
  List<String> currentConventionalSubcategoryOptions = ['Select an Option'];
  List<String> currentCommercialSubcategoryOptions = ['Select an Option'];

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
  List<String> images = [];
  bool loading = false;

  Future<void> onSendRequest() async {
    File requestFile = await assetImageToFile(AppImages.propertySearch);
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    print(address.text);
    print(price);
    print(bathroom);
    print(beds);
    print(furnished);
    print(garage);
    print(images[0]);
    print(selectedPurchaseType);

    if (address.text.isEmpty ||
        title.text.isEmpty ||
        country.text.isEmpty ||
        state.text.isEmpty) {
      showToast(
        message: 'Incomplete property details',
        context: context,
        isAlert: true,
        color: Colors.redAccent,
      );
      setState(() {
        loading = false;
      });
    } else if ((selectedRequestType == 'offering' && images.isEmpty)) {
      showToast(
        message: 'Provide Pictures',
        context: context,
        isAlert: true,
        color: Colors.redAccent,
      );
      setState(() {
        loading = false;
      });
    } else if (selectedInvestmentType == '' ||
        // selectedInvestmentSubcategory == '' ||
        selectedPurchaseType == '' ||
        selectedCondition == '' ||
        selectedRequestType == '' ||
        selectedLandArea.text.isEmpty ||
        selectedBuildingArea.text.isEmpty ||
        selectedBuildableArea.text.isEmpty ||
        beds == 0 ||
        bathroom == 0 ||
        price == 0 ||
        furnished == '') {
      print(selectedInvestmentSubcategory);
      print(selectedInvestmentType);
      showToast(
        message: "Incomplete property details!",
        context: context,
        isAlert: true,
        color: Colors.redAccent,
      );
      setState(() {
        loading = false;
      });
    } else {
      Map<String, dynamic> response =
          await RealEstateProvider.c(context).addProperty(
        title: title.text,
        country: country.text,
        address: address.text,
        district: state.text,
        city: city.text,
        shortDescription: description.text,
        investmentType: selectedInvestmentType,
        investmentSubcategory: selectedInvestmentSubcategory,
        // investmentSubcategory: 'Small House',
        requestType: selectedRequestType,
        condition: selectedCondition,
        purchaseType: selectedPurchaseType,
        propertyType: selectedPropertyType,
        landArea: double.parse(selectedLandArea.text),
        buildingUsageArea: double.parse(selectedBuildingArea.text),
        buildableArea: double.parse(selectedBuildableArea.text),
        bathrooms: bathroom,
        beds: beds,
        rooms: beds,
        price: price.toDouble(),
        equipment: equipment.text,
        qualityOfEquipment: qualityOfEquipment.text,
        isFurnished: furnished == 'yes' ? true : false,
        garage: garage == 'yes' ? true : false,
        pictures: selectedRequestType == 'requesting'
            ? [
                requestFile.path,
              ]
            : images,
        postedBy: id,
        parkingPlaces:
            parkingPlaces.text.isNotEmpty ? int.parse(parkingPlaces.text) : 0,
      );
      if (response['message'] == 'Property added successfully') {
        showToast(message: response['message'], context: context);
        setState(() {
          loading = false;
        });
        await RealEstateProvider.c(context).fetchAllListings();
        Navigator.pop(context);
      } else {
        showToast(
          message: response['message'],
          context: context,
          isAlert: true,
          color: Colors.redAccent,
        );
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<List<String>> _pickFile(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      return pickedFiles.map((xfile) => xfile.path).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final propertyRequestProvider =
        Provider.of<OfferRequestPropertyContentProvider>(context,
            listen: false);
    return Screen(
      overlayWidgets: [
        if (loading)
          const FullScreenLoader(
            loading: true,
          )
      ],
      child: Scaffold(
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
                  propertyRequestProvider.content!.title,
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
                  propertyRequestProvider.content!.offerSelectionTagLine,
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
                  propertyRequestProvider.content!.conditionTagLine,
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
                  propertyRequestProvider.content!.investmentTypeTagLine,
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
        questionText("Investment type"),
        OutlinedDropdownButtonExample(
          list: commercialPropertyCategory,
          onSelected: (value) {
            setState(() {
              selectedInvestmentType = value;
              int selectedCategoryIndex =
                  commercialPropertyCategory.indexOf(value);
              currentCommercialSubcategoryOptions =
                  commercialPropertySubcategory[selectedCategoryIndex];

              selectedInvestmentSubcategory =
                  currentCommercialSubcategoryOptions.isNotEmpty
                      ? currentCommercialSubcategoryOptions[0]
                      : ''; // Empty if no subcategory available
            });
            print(selectedInvestmentSubcategory);
          },
          initial: commercialPropertyCategory.isNotEmpty
              ? commercialPropertyCategory[0]
              : '',
          label: 'Investment Type',
        ),
        SizedBox(
          height: 8.w,
        ),
        questionText("Investment subcategory"),
        OutlinedDropdownButtonExample(
          list: currentCommercialSubcategoryOptions,
          onSelected: (value) {
            setState(() {
              selectedInvestmentSubcategory = value;
            });
          },
          // Set the initial value for the subcategory dropdown to selectedInvestmentSubcategory
          initial: currentCommercialSubcategoryOptions.isNotEmpty
              ? selectedInvestmentSubcategory.isNotEmpty
                  ? selectedInvestmentSubcategory
                  : currentCommercialSubcategoryOptions[0]
              : '', // If no subcategory selected, fallback to the first subcategory
          label: 'Investment Subcategory',
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
        selectedRequestType == 'requesting'
            ? const SizedBox()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  questionText("Add pictures"),
                  SizedBox(
                    height: 6.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      _pickFile(context).then((pickedImages) {
                        setState(() {
                          images.addAll(pickedImages);
                        });
                      });
                    },
                    child: Container(
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
                  ),
                  SizedBox(
                    height: 10.w,
                  ),
                  imagesContainer(context),
                ],
              ),
        SizedBox(
          height: 10.w,
        ),
        GestureDetector(
          onTap: onSendRequest,
          child: const CustomButton(
            text: "Post",
          ),
        ),
      ],
    );
  }

  Widget conventionalContent() {
    selectedInvestmentSubcategory = '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        questionText("Investment type"),
        DropdownButton2Example(
          list: conventionalPropertyCategory,
          onSelected: (value) {
            setState(() {
              selectedInvestmentType = value;
              int selectedCategoryIndex =
                  conventionalPropertyCategory.indexOf(value);
              currentConventionalSubcategoryOptions =
                  conventionalPropertySubcategory[selectedCategoryIndex];
              selectedInvestmentSubcategory =
                  currentConventionalSubcategoryOptions.isNotEmpty
                      ? currentConventionalSubcategoryOptions[0]
                      : '';
            });
            print(selectedInvestmentSubcategory);
          },
          initial: conventionalPropertyCategory.isNotEmpty
              ? conventionalPropertyCategory[0]
              : '',
          label: 'Investment Type',
        ),
        SizedBox(
          height: 8.w,
        ),
        questionText("Investment subcategory"),
        DropdownButton2Example(
          list: currentConventionalSubcategoryOptions,
          onSelected: (value) {
            print(value);
            setState(() {
              selectedInvestmentSubcategory = value;
            });

            print(selectedInvestmentSubcategory);
          },
          initial: currentConventionalSubcategoryOptions.isNotEmpty
              ? selectedInvestmentSubcategory.isNotEmpty
                  ? selectedInvestmentSubcategory
                  : currentConventionalSubcategoryOptions[0]
              : '',
          label: 'Investment Subcategory',
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
        selectedRequestType == 'requesting'
            ? const SizedBox()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  questionText("Add pictures"),
                  SizedBox(
                    height: 6.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      _pickFile(context).then((pickedImages) {
                        setState(() {
                          images.addAll(pickedImages);
                        });
                      });
                    },
                    child: Container(
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
                  ),
                  SizedBox(
                    height: 10.w,
                  ),
                  imagesContainer(context),
                ],
              ),
        SizedBox(
          height: 10.w,
        ),
        GestureDetector(
          onTap: onSendRequest,
          child: const CustomButton(
            text: "Post",
          ),
        ),
      ],
    );
  }

  Widget imagesContainer(BuildContext context) {
    return images.isNotEmpty
        ? LayoutBuilder(
            builder: (context, constraints) {
              int rows = (images.length / 3).ceil();
              double totalHeight =
                  (rows * MediaQuery.of(context).size.width * 0.315) +
                      ((rows - 1) * 4.0);

              return SizedBox(
                height: totalHeight,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(images[index]),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        Positioned(
                          right: 6,
                          top: 6,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                images.removeAt(index);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: AppColors.lightBlue,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              );
            },
          )
        : const Center(
            child: Text('No images selected'),
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
