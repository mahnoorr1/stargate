// ignore_for_file: unnecessary_nullable_for_final_variable_declarations, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/features/content_management/providers/offer_request_property_content_provider.dart';
import 'package:stargate/localization/locale_notifier.dart';
import 'package:stargate/models/real_estate_listing.dart';
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
import 'package:stargate/widgets/translationWidget.dart';

import '../../localization/localization.dart';
import '../../localization/translation_strings.dart';
import '../../services/helper_methods.dart';

class PropertyRequestForm extends StatefulWidget {
  bool? isEditingEnabled = false;
  RealEstateListing? listing;
  PropertyRequestForm({
    super.key,
    this.isEditingEnabled,
    this.listing,
  });

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

  TextEditingController bedsController = TextEditingController();
  TextEditingController bathsController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  List<String> requestTypeList = ['offering', 'requesting'];
  List<String> currentConventionalSubcategoryOptions = [];
  List<String> currentCommercialSubcategoryOptions = [];

  String selectedRequestType = '';
  String selectedCondition = '';
  String selectedPurchaseType = '';
  String selectedPropertyType = '';

  String selectedInvestmentType = '';
  String selectedInvestmentSubcategory = '';
  String selectedInvestmentConventionalSubcategory = '';
  int beds = 0;
  int bathroom = 0;
  int price = 0;
  String furnished = '';
  String garage = '';
  List<String> images = [];
  List<String> existingImages = [];
  bool loading = false;
  int selectedIndexOfPropertyCategory = 0;
  int propertyIndexConventional = 0;
  int indexOfSubcategory = 0;
  final _formKey = GlobalKey<FormState>();

  Future<void> onSendRequest() async {
    File requestFile = await assetImageToFile(AppImages.propertySearch);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    log('Address: ${address.text}');
    log('Price: ${priceController.text}');
    log('Bathrooms: ${bathsController.text}');
    log('Beds: ${bedsController.text}');
    log('Furnished: $furnished');
    log('Garage: $garage');
    log('Images: ${images.isNotEmpty ? images[0] : 'No images'}');
    log('Purchase Type: $selectedPurchaseType');
    if (!_formKey.currentState!.validate() ||
        selectedInvestmentType == '' ||
        selectedPurchaseType == '' ||
        selectedCondition == '' ||
        selectedRequestType == '' ||
        selectedLandArea.text.isEmpty ||
        selectedBuildingArea.text.isEmpty ||
        selectedBuildableArea.text.isEmpty ||
        bedsController.text.isEmpty ||
        bathsController.text.isEmpty ||
        priceController.text.isEmpty) {
      print(selectedInvestmentConventionalSubcategory);
      showToast(
        message: AppLocalization.of(context)!
            .translate(TranslationString.incompletePropertyDetails),
        context: context,
        isAlert: true,
        color: Colors.redAccent,
      );
      setState(() {
        loading = false;
      });
    } else if ((selectedRequestType == 'offering' && images.isEmpty)) {
      showToast(
        message: AppLocalization.of(context)!
            .translate(TranslationString.providePictures),
        context: context,
        isAlert: true,
        color: Colors.redAccent,
      );
      setState(() {
        loading = false;
      });
    } else if ((selectedPropertyType == 'commercial' &&
            selectedInvestmentSubcategory == '') ||
        selectedPropertyType == 'conventional' &&
            selectedInvestmentConventionalSubcategory == '') {
      print("subcategroy");
      print(selectedInvestmentConventionalSubcategory);
      print(conventionalPropertySubcategory[propertyIndexConventional]
          [indexOfSubcategory]);
      showToast(
        message: AppLocalization.of(context)!
            .translate(TranslationString.incompletePropertyDetails),
        context: context,
        isAlert: true,
        color: Colors.redAccent,
      );
      setState(() {
        loading = false;
      });
      return;
    } else {
      setState(() {
        loading = true;
      });
      Map<String, dynamic> response =
          await RealEstateProvider.c(context).addProperty(
        title: title.text,
        country: country.text,
        address: address.text,
        district: state.text,
        city: city.text,
        shortDescription: description.text,
        investmentType: selectedInvestmentType,
        investmentSubcategory: selectedPropertyType == 'commercial'
            ? selectedInvestmentSubcategory
            : selectedInvestmentConventionalSubcategory,
        // investmentSubcategory: 'Small House',
        requestType: selectedRequestType,
        condition: selectedCondition,
        purchaseType: selectedPurchaseType,
        propertyType: selectedPropertyType,
        landArea: double.parse(selectedLandArea.text),
        buildingUsageArea: double.parse(selectedBuildingArea.text),
        buildableArea: double.parse(selectedBuildableArea.text),
        bathrooms: int.parse(bathsController.text),
        beds: int.parse(bedsController.text),
        rooms: int.parse(bedsController.text),
        price: double.parse(priceController.text),
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
        showToast(
            message: AppLocalization.of(context)!
                .translate(TranslationString.propertyAddedSuccessfully),
            context: context);
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

  void updateProperty() async {
    setState(() => loading = true);
    print("updating now");
    try {
      String success =
          await RealEstateProvider.c(context).updateExistingProperty(
        propertyId: widget.listing!.id!,
        title: title.text,
        country: country.text,
        requestType: selectedRequestType,
        condition: selectedCondition,
        purchaseType: selectedPurchaseType,
        propertyType: selectedPropertyType,
        landArea: selectedLandArea.text,
        buildingUsageArea: selectedBuildingArea.text,
        buildableArea: selectedBuildableArea.text,
        bathrooms: bathsController.text,
        price: priceController.text,
        newImagePaths: images, // List of new image file paths
        existingImageUrls: existingImages, // List of existing image URLs
        address: address.text,
        district: state.text,
        city: city.text,
        shortDescription: description.text,
        investmentType: selectedInvestmentType,
        investmentSubcategory: selectedInvestmentSubcategory,
        beds: bedsController.text,
        rooms: bedsController.text,
        isFurnished: furnished,
        garage: garage,
        parkingPlaces: parkingPlaces.text,
      );

      if (success == 'Property updated successfully') {
        showToast(
            message: AppLocalization.of(context)!
                .translate(TranslationString.propertyUpdateSuccess),
            context: context,
            color: AppColors.blue);
        Navigator.pop(context);
      } else {
        showToast(
            message: AppLocalization.of(context)!
                .translate(TranslationString.propertyUpdateFailed),
            context: context,
            color: Colors.redAccent);
      }
    } catch (e) {
      showToast(
          message:
              AppLocalization.of(context)!.translate(TranslationString.error),
          context: context,
          color: Colors.redAccent);
    } finally {
      setState(() => loading = false);
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
  void initState() {
    super.initState();
    if (widget.isEditingEnabled == true && widget.listing != null) {
      title.text = widget.listing!.title;
      country.text = widget.listing!.country;
      address.text = widget.listing!.address;
      state.text = widget.listing!.state ?? '';
      city.text = widget.listing!.city!;
      description.text = widget.listing!.description;
      selectedInvestmentType = widget.listing!.propertyCategory;
      selectedInvestmentSubcategory = widget.listing!.propertySubCategory;
      // investmentSubcategory: 'Small House',
      selectedRequestType = widget.listing!.requestType;
      selectedCondition = widget.listing!.condition;
      selectedPurchaseType = widget.listing!.sellingType;
      selectedPropertyType = widget.listing!.propertyType;
      selectedLandArea.text = widget.listing!.landAreaInTotal.toString();
      selectedBuildingArea.text = widget.listing!.occupiedLandArea.toString();
      selectedBuildableArea.text = widget.listing!.buildableArea.toString();
      bathsController.text = widget.listing!.noOfBathrooms.toString();
      bedsController.text = widget.listing!.noOfBeds.toString();
      bedsController.text = widget.listing!.noOfBeds.toString();
      priceController.text = widget.listing!.price.toString();
      equipment.text = widget.listing!.equipment ?? '';
      qualityOfEquipment.text = widget.listing!.qualityOfEquipment ?? '';
      furnished = widget.listing!.furnished == true ? 'yes' : 'no';
      garage = widget.listing!.garage == true ? 'yes' : 'no';
      //pictures initialization
      existingImages = widget.listing!.pictures ?? [];
      parkingPlaces.text = widget.listing!.parkingPlaces.toString();
      selectedIndexOfPropertyCategory = widget.listing!.propertyType ==
              'commercial'
          ? commercialPropertyCategory.indexOf(widget.listing!.propertyCategory)
          : conventionalPropertyCategory
              .indexOf(widget.listing!.propertyCategory);
      propertyIndexConventional = widget.listing!.propertyType == 'commercial'
          ? 0
          : conventionalPropertyCategory
              .indexOf(widget.listing!.propertyCategory);
      indexOfSubcategory = widget.listing!.propertyType == 'commercial'
          ? commercialPropertySubcategory[selectedIndexOfPropertyCategory]
              .indexOf(widget.listing!.propertySubCategory)
          : conventionalPropertySubcategory[selectedIndexOfPropertyCategory]
              .indexOf(widget.listing!.propertySubCategory);

      print(indexOfSubcategory);
      print(widget.listing!.propertySubCategory);
      print(selectedIndexOfPropertyCategory);
      selectedInvestmentConventionalSubcategory =
          widget.listing!.propertySubCategory;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeNotifier = Provider.of<LocaleNotifier>(context);
    final locale = localeNotifier.locale;
    final targetLang = locale.languageCode;
    currentConventionalSubcategoryOptions = [
      AppLocalization.of(context)!.translate(TranslationString.selectOption)
    ];
    currentCommercialSubcategoryOptions = [
      AppLocalization.of(context)!.translate(TranslationString.selectOption)
    ];
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  translationWidget(
                    propertyRequestProvider.content!.title,
                    context,
                    propertyRequestProvider.content!.title,
                    AppStyles.screenTitle.copyWith(
                      color: AppColors.darkBlue,
                    ),
                  ),
                  SizedBox(
                    height: 16.w,
                  ),
                  CustomTextField(
                    controller: title,
                    label: AppLocalization.of(context)!
                        .translate(TranslationString.title),
                    hintText: AppLocalization.of(context)!
                        .translate(TranslationString.title),
                    inputType: TextInputType.text,
                    horizontalSpacing: 0,
                    verticalSpacing: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '${AppLocalization.of(context)!.translate(TranslationString.title)} ${AppLocalization.of(context)!.translate(TranslationString.canNotBeEmpty)}'; // Error message
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 3.w,
                  ),
                  CustomTextField(
                    controller: address,
                    label: AppLocalization.of(context)!
                        .translate(TranslationString.address),
                    hintText: AppLocalization.of(context)!
                        .translate(TranslationString.address),
                    inputType: TextInputType.text,
                    horizontalSpacing: 0,
                    verticalSpacing: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '${AppLocalization.of(context)!.translate(TranslationString.address)} ${AppLocalization.of(context)!.translate(TranslationString.canNotBeEmpty)}'; // Error message
                      }
                      return null;
                    },
                  ),
                  CountryPickerField(
                    initalCountry: country.text,
                    initialCity: city.text,
                    initialState: state.text,
                    country: country,
                    state: state,
                    city: city,
                  ),
                  country.text.isEmpty
                      ? Text(
                          AppLocalization.of(context)!
                              .translate(TranslationString.selectCountryError),
                          style:
                              TextStyle(color: Colors.red[900], fontSize: 12),
                        )
                      : const SizedBox(),
                  selectedRequestType == 'requesting'
                      ? const SizedBox()
                      : CustomTextField(
                          controller: description,
                          label: AppLocalization.of(context)!
                              .translate(TranslationString.description),
                          hintText: AppLocalization.of(context)!
                              .translate(TranslationString.description),
                          inputType: TextInputType.text,
                          horizontalSpacing: 0,
                          verticalSpacing: 3,
                          maxLines: 4,
                        ),
                  SizedBox(
                    height: 10.w,
                  ),
                  translationWidget(
                    propertyRequestProvider.content!.offerSelectionTagLine,
                    context,
                    propertyRequestProvider.content!.offerSelectionTagLine,
                    AppStyles.heading4.copyWith(color: AppColors.darkBlue),
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
                  selectedRequestType == ''
                      ? Text(
                          AppLocalization.of(context)!
                              .translate(TranslationString.selectionRequired),
                          style:
                              TextStyle(color: Colors.red[900], fontSize: 12),
                        )
                      : const SizedBox(),
                  SizedBox(
                    height: 8.w,
                  ),
                  translationWidget(
                    propertyRequestProvider.content!.conditionTagLine,
                    context,
                    propertyRequestProvider.content!.conditionTagLine,
                    AppStyles.heading4.copyWith(color: AppColors.darkBlue),
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
                  selectedCondition == ''
                      ? Text(
                          AppLocalization.of(context)!
                              .translate(TranslationString.selectionRequired),
                          style:
                              TextStyle(color: Colors.red[900], fontSize: 12),
                        )
                      : const SizedBox(),
                  SizedBox(
                    height: 8.w,
                  ),
                  questionText(AppLocalization.of(context)!
                      .translate(TranslationString.purchase)),
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
                  selectedPurchaseType == ''
                      ? Text(
                          AppLocalization.of(context)!
                              .translate(TranslationString.selectionRequired),
                          style:
                              TextStyle(color: Colors.red[900], fontSize: 12),
                        )
                      : const SizedBox(),
                  SizedBox(
                    height: 8.w,
                  ),
                  translationWidget(
                    propertyRequestProvider.content!.investmentTypeTagLine,
                    context,
                    propertyRequestProvider.content!.investmentTypeTagLine,
                    AppStyles.heading4.copyWith(color: AppColors.darkBlue),
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
                  selectedPropertyType == ''
                      ? Text(
                          AppLocalization.of(context)!
                              .translate(TranslationString.selectionRequired),
                          style:
                              TextStyle(color: Colors.red[900], fontSize: 12),
                        )
                      : const SizedBox(),
                  SizedBox(
                    height: 12.w,
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
        questionText(AppLocalization.of(context)!
            .translate(TranslationString.investmentType)),
        OutlinedDropdownButtonExample(
          list: commercialPropertyCategory,
          onSelected: (value) {
            setState(() {
              selectedInvestmentType = value;
              selectedIndexOfPropertyCategory =
                  commercialPropertyCategory.indexOf(value);
              currentCommercialSubcategoryOptions = List.from(
                  commercialPropertySubcategory[
                      selectedIndexOfPropertyCategory]);
              selectedInvestmentSubcategory =
                  currentCommercialSubcategoryOptions.isNotEmpty
                      ? currentCommercialSubcategoryOptions[0]
                      : '';
              setState(() {});
            });
          },
          initial: widget.isEditingEnabled == true
              ? selectedInvestmentType
              : commercialPropertyCategory.isNotEmpty
                  ? commercialPropertyCategory[0]
                  : '',
          label: AppLocalization.of(context)!
              .translate(TranslationString.investmentType),
        ),
        SizedBox(
          height: 8.w,
        ),
        questionText(AppLocalization.of(context)!
            .translate(TranslationString.investmentSubcategory)),
        selectedIndexOfPropertyCategory == 0
            ? OutlinedDropdownButtonExample(
                list: commercialPropertySubcategory[0],
                onSelected: (value) {
                  setState(() {
                    selectedInvestmentSubcategory = value;
                  });
                },
                initial: commercialPropertySubcategory[0][0],
                label: AppLocalization.of(context)!
                    .translate(TranslationString.investmentSubcategory),
              )
            : selectedIndexOfPropertyCategory == 1
                ? OutlinedDropdownButtonExample(
                    list: commercialPropertySubcategory[1],
                    onSelected: (value) {
                      setState(() {
                        selectedInvestmentSubcategory = value;
                        indexOfSubcategory =
                            commercialPropertySubcategory[1].indexOf(value);
                      });
                    },
                    initial: widget.isEditingEnabled == true
                        ? commercialPropertySubcategory[1][indexOfSubcategory]
                        : commercialPropertySubcategory[1][0],
                    label: AppLocalization.of(context)!
                        .translate(TranslationString.investmentSubcategory),
                  )
                : selectedIndexOfPropertyCategory == 2
                    ? OutlinedDropdownButtonExample(
                        list: commercialPropertySubcategory[2],
                        onSelected: (value) {
                          setState(() {
                            selectedInvestmentSubcategory = value;
                            indexOfSubcategory =
                                commercialPropertySubcategory[2].indexOf(value);
                          });
                        },
                        initial: widget.isEditingEnabled == true
                            ? commercialPropertySubcategory[2]
                                [indexOfSubcategory]
                            : commercialPropertySubcategory[2][0],
                        label: AppLocalization.of(context)!
                            .translate(TranslationString.investmentSubcategory),
                      )
                    : selectedIndexOfPropertyCategory == 3
                        ? OutlinedDropdownButtonExample(
                            list: commercialPropertySubcategory[3],
                            onSelected: (value) {
                              setState(() {
                                selectedInvestmentSubcategory = value;
                                indexOfSubcategory =
                                    commercialPropertySubcategory[3]
                                        .indexOf(value);
                              });
                            },
                            initial: widget.isEditingEnabled == true
                                ? commercialPropertySubcategory[3]
                                    [indexOfSubcategory]
                                : commercialPropertySubcategory[3][0],
                            label: AppLocalization.of(context)!.translate(
                                TranslationString.investmentSubcategory),
                          )
                        : selectedIndexOfPropertyCategory == 4
                            ? OutlinedDropdownButtonExample(
                                list: commercialPropertySubcategory[4],
                                onSelected: (value) {
                                  setState(() {
                                    selectedInvestmentSubcategory = value;
                                    indexOfSubcategory =
                                        commercialPropertySubcategory[4]
                                            .indexOf(value);
                                  });
                                },
                                initial: widget.isEditingEnabled == true
                                    ? commercialPropertySubcategory[4]
                                        [indexOfSubcategory]
                                    : commercialPropertySubcategory[4][0],
                                label: AppLocalization.of(context)!.translate(
                                    TranslationString.investmentSubcategory),
                              )
                            : selectedIndexOfPropertyCategory == 5
                                ? OutlinedDropdownButtonExample(
                                    list: commercialPropertySubcategory[5],
                                    onSelected: (value) {
                                      setState(() {
                                        selectedInvestmentSubcategory = value;
                                        indexOfSubcategory =
                                            commercialPropertySubcategory[5]
                                                .indexOf(value);
                                      });
                                    },
                                    initial: widget.isEditingEnabled == true
                                        ? commercialPropertySubcategory[5]
                                            [indexOfSubcategory]
                                        : commercialPropertySubcategory[5][0],
                                    label: AppLocalization.of(context)!
                                        .translate(TranslationString
                                            .investmentSubcategory),
                                  )
                                : selectedIndexOfPropertyCategory == 6
                                    ? OutlinedDropdownButtonExample(
                                        list: commercialPropertySubcategory[6],
                                        onSelected: (value) {
                                          setState(() {
                                            selectedInvestmentSubcategory =
                                                value;
                                            indexOfSubcategory =
                                                commercialPropertySubcategory[6]
                                                    .indexOf(value);
                                          });
                                        },
                                        initial: widget.isEditingEnabled == true
                                            ? commercialPropertySubcategory[6]
                                                [indexOfSubcategory]
                                            : commercialPropertySubcategory[6]
                                                [0],
                                        label: AppLocalization.of(context)!
                                            .translate(TranslationString
                                                .investmentSubcategory),
                                      )
                                    : selectedIndexOfPropertyCategory == 7
                                        ? OutlinedDropdownButtonExample(
                                            list: commercialPropertySubcategory[
                                                7],
                                            onSelected: (value) {
                                              setState(() {
                                                selectedInvestmentSubcategory =
                                                    value;
                                                indexOfSubcategory =
                                                    commercialPropertySubcategory[
                                                            7]
                                                        .indexOf(value);
                                              });
                                            },
                                            initial: widget.isEditingEnabled ==
                                                    true
                                                ? commercialPropertySubcategory[
                                                    7][indexOfSubcategory]
                                                : commercialPropertySubcategory[
                                                    7][0],
                                            label: AppLocalization.of(context)!
                                                .translate(TranslationString
                                                    .investmentSubcategory),
                                          )
                                        : OutlinedDropdownButtonExample(
                                            list: commercialPropertySubcategory[
                                                8],
                                            onSelected: (value) {
                                              setState(() {
                                                selectedInvestmentSubcategory =
                                                    value;
                                                indexOfSubcategory =
                                                    commercialPropertySubcategory[
                                                            8]
                                                        .indexOf(value);
                                              });
                                            },
                                            initial: widget.isEditingEnabled ==
                                                    true
                                                ? commercialPropertySubcategory[
                                                    8][indexOfSubcategory]
                                                : commercialPropertySubcategory[
                                                    8][0],
                                            label: AppLocalization.of(context)!
                                                .translate(TranslationString
                                                    .investmentSubcategory),
                                          ),
        SizedBox(
          height: 6.w,
        ),
        CustomTextField(
          controller: selectedLandArea,
          label: AppLocalization.of(context)!
              .translate(TranslationString.landAreaInM2),
          hintText: AppLocalization.of(context)!
              .translate(TranslationString.landAreaInM2),
          inputType: TextInputType.number,
          horizontalSpacing: 0,
          verticalSpacing: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '${AppLocalization.of(context)!.translate(TranslationString.landArea)} ${AppLocalization.of(context)!.translate(TranslationString.canNotBeEmpty)}'; // Error message
            }
            return null;
          },
        ),
        SizedBox(
          height: 3.w,
        ),
        CustomTextField(
          controller: selectedBuildingArea,
          label: AppLocalization.of(context)!
              .translate(TranslationString.buildingUsageAreaInM2),
          hintText: AppLocalization.of(context)!
              .translate(TranslationString.buildingUsageAreaInM2),
          inputType: TextInputType.number,
          horizontalSpacing: 0,
          verticalSpacing: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '${AppLocalization.of(context)!.translate(TranslationString.buildingUsageArea)} ${AppLocalization.of(context)!.translate(TranslationString.canNotBeEmpty)}'; // Error message
            }
            return null;
          },
        ),
        SizedBox(
          height: 3.w,
        ),
        CustomTextField(
          controller: selectedBuildableArea,
          label: AppLocalization.of(context)!
              .translate(TranslationString.buildableAreaInM2),
          hintText: AppLocalization.of(context)!
              .translate(TranslationString.buildableAreaInM2),
          inputType: TextInputType.number,
          horizontalSpacing: 0,
          verticalSpacing: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '${AppLocalization.of(context)!.translate(TranslationString.buildableAreaInM2)} ${AppLocalization.of(context)!.translate(TranslationString.canNotBeEmpty)}'; // Error message
            }
            return null;
          },
        ),
        SizedBox(
          height: 10.w,
        ),
        sliderSelections(),
        SizedBox(
          height: 10.w,
        ),
        questionText(AppLocalization.of(context)!
            .translate(TranslationString.furnished)),
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
        furnished == 'no'
            ? const SizedBox()
            : CustomTextField(
                controller: equipment,
                label: AppLocalization.of(context)!
                    .translate(TranslationString.anyEquipments),
                hintText: AppLocalization.of(context)!
                    .translate(TranslationString.anyEquipments),
                inputType: TextInputType.text,
                horizontalSpacing: 0,
                verticalSpacing: 3,
              ),
        SizedBox(
          height: 3.w,
        ),
        furnished == 'no'
            ? const SizedBox()
            : CustomTextField(
                controller: qualityOfEquipment,
                label: AppLocalization.of(context)!
                    .translate(TranslationString.qualityOfEquipmentsSmall),
                hintText: AppLocalization.of(context)!
                    .translate(TranslationString.qualityOfEquipmentsSmall),
                inputType: TextInputType.text,
                horizontalSpacing: 0,
                verticalSpacing: 3,
              ),
        SizedBox(
          height: 3.w,
        ),
        CustomTextField(
          controller: parkingPlaces,
          label: AppLocalization.of(context)!
              .translate(TranslationString.noOfParkingPlaces),
          hintText: AppLocalization.of(context)!
              .translate(TranslationString.noOfParkingPlaces),
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
                  questionText(AppLocalization.of(context)!
                      .translate(TranslationString.addPictures)),
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
          onTap:
              widget.isEditingEnabled == true ? updateProperty : onSendRequest,
          child: CustomButton(
            text: widget.isEditingEnabled == true
                ? AppLocalization.of(context)!
                    .translate(TranslationString.update)
                : AppLocalization.of(context)!
                    .translate(TranslationString.post),
          ),
        ),
      ],
    );
  }

  Widget conventionalContent() {
    int selectedIndex = 0;
    selectedInvestmentSubcategory = '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        questionText(AppLocalization.of(context)!
            .translate(TranslationString.investmentType)),
        DropdownButton2Example(
          list: conventionalPropertyCategory,
          onSelected: (value) {
            setState(() {
              selectedInvestmentType = value;
              propertyIndexConventional =
                  conventionalPropertyCategory.indexOf(value);
              currentConventionalSubcategoryOptions =
                  List.from(conventionalPropertySubcategory[selectedIndex]);
              selectedInvestmentConventionalSubcategory =
                  currentConventionalSubcategoryOptions.isNotEmpty
                      ? currentConventionalSubcategoryOptions[0]
                      : '';
            });
          },
          initial: widget.isEditingEnabled == true
              ? conventionalPropertyCategory[selectedIndexOfPropertyCategory]
              : conventionalPropertyCategory.isNotEmpty
                  ? conventionalPropertyCategory[0]
                  : '',
          label: AppLocalization.of(context)!
              .translate(TranslationString.investmentType),
        ),
        SizedBox(
          height: 8.w,
        ),
        questionText(AppLocalization.of(context)!
            .translate(TranslationString.investmentSubcategory)),
        propertyIndexConventional == 0
            ? OutlinedDropdownButtonExample(
                list: conventionalPropertySubcategory[0],
                onSelected: (value) {
                  setState(() {
                    selectedInvestmentConventionalSubcategory = value;
                    indexOfSubcategory =
                        conventionalPropertySubcategory[0].indexOf(value);
                  });
                },
                initial: conventionalPropertySubcategory[0][0],
                label: AppLocalization.of(context)!
                    .translate(TranslationString.investmentSubcategory),
              )
            : propertyIndexConventional == 1
                ? OutlinedDropdownButtonExample(
                    list: conventionalPropertySubcategory[1],
                    onSelected: (value) {
                      setState(() {
                        selectedInvestmentConventionalSubcategory = value;
                        indexOfSubcategory =
                            conventionalPropertySubcategory[1].indexOf(value);
                      });
                    },
                    initial: widget.isEditingEnabled == true
                        ? conventionalPropertySubcategory[1][indexOfSubcategory]
                        : conventionalPropertySubcategory[1][0],
                    label: AppLocalization.of(context)!
                        .translate(TranslationString.investmentSubcategory),
                  )
                : propertyIndexConventional == 2
                    ? OutlinedDropdownButtonExample(
                        list: conventionalPropertySubcategory[2],
                        onSelected: (value) {
                          setState(() {
                            selectedInvestmentConventionalSubcategory = value;
                            indexOfSubcategory =
                                conventionalPropertySubcategory[2]
                                    .indexOf(value);
                          });
                        },
                        initial: widget.isEditingEnabled == true
                            ? conventionalPropertySubcategory[2]
                                [indexOfSubcategory]
                            : conventionalPropertySubcategory[2][0],
                        label: AppLocalization.of(context)!
                            .translate(TranslationString.investmentSubcategory),
                      )
                    : propertyIndexConventional == 3
                        ? OutlinedDropdownButtonExample(
                            list: conventionalPropertySubcategory[3],
                            onSelected: (value) {
                              setState(() {
                                selectedInvestmentConventionalSubcategory =
                                    value;
                                indexOfSubcategory =
                                    conventionalPropertySubcategory[3]
                                        .indexOf(value);
                              });
                            },
                            initial: widget.isEditingEnabled == true
                                ? conventionalPropertySubcategory[3]
                                    [indexOfSubcategory]
                                : conventionalPropertySubcategory[3][0],
                            label: AppLocalization.of(context)!.translate(
                                TranslationString.investmentSubcategory),
                          )
                        : propertyIndexConventional == 4
                            ? OutlinedDropdownButtonExample(
                                list: conventionalPropertySubcategory[4],
                                onSelected: (value) {
                                  setState(() {
                                    selectedInvestmentConventionalSubcategory =
                                        value;
                                    indexOfSubcategory =
                                        conventionalPropertySubcategory[4]
                                            .indexOf(value);
                                  });
                                },
                                initial: widget.isEditingEnabled == true
                                    ? conventionalPropertySubcategory[4]
                                        [indexOfSubcategory]
                                    : conventionalPropertySubcategory[4][0],
                                label: AppLocalization.of(context)!.translate(
                                    TranslationString.investmentSubcategory),
                              )
                            : propertyIndexConventional == 5
                                ? OutlinedDropdownButtonExample(
                                    list: conventionalPropertySubcategory[5],
                                    onSelected: (value) {
                                      setState(() {
                                        selectedInvestmentConventionalSubcategory =
                                            value;
                                        indexOfSubcategory =
                                            conventionalPropertySubcategory[5]
                                                .indexOf(value);
                                      });
                                    },
                                    initial: widget.isEditingEnabled == true
                                        ? conventionalPropertySubcategory[5]
                                            [indexOfSubcategory]
                                        : conventionalPropertySubcategory[5][0],
                                    label: AppLocalization.of(context)!
                                        .translate(TranslationString
                                            .investmentSubcategory),
                                  )
                                : propertyIndexConventional == 6
                                    ? OutlinedDropdownButtonExample(
                                        list:
                                            conventionalPropertySubcategory[6],
                                        onSelected: (value) {
                                          setState(() {
                                            selectedInvestmentConventionalSubcategory =
                                                value;
                                            indexOfSubcategory =
                                                conventionalPropertySubcategory[
                                                        6]
                                                    .indexOf(value);
                                          });
                                        },
                                        initial: widget.isEditingEnabled == true
                                            ? conventionalPropertySubcategory[6]
                                                [indexOfSubcategory]
                                            : conventionalPropertySubcategory[6]
                                                [0],
                                        label: AppLocalization.of(context)!
                                            .translate(TranslationString
                                                .investmentSubcategory),
                                      )
                                    : OutlinedDropdownButtonExample(
                                        list:
                                            conventionalPropertySubcategory[7],
                                        onSelected: (value) {
                                          setState(() {
                                            selectedInvestmentConventionalSubcategory =
                                                value;
                                            indexOfSubcategory =
                                                conventionalPropertySubcategory[
                                                        7]
                                                    .indexOf(value);
                                          });
                                        },
                                        initial: widget.isEditingEnabled == true
                                            ? conventionalPropertySubcategory[7]
                                                [indexOfSubcategory]
                                            : conventionalPropertySubcategory[7]
                                                [0],
                                        label: AppLocalization.of(context)!
                                            .translate(TranslationString
                                                .investmentSubcategory),
                                      ),
        SizedBox(
          height: 6.w,
        ),
        CustomTextField(
          controller: selectedLandArea,
          label: AppLocalization.of(context)!
              .translate(TranslationString.landAreaInM2),
          hintText: AppLocalization.of(context)!
              .translate(TranslationString.landAreaInM2),
          inputType: TextInputType.number,
          horizontalSpacing: 0,
          verticalSpacing: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '${AppLocalization.of(context)!.translate(TranslationString.landArea)} ${AppLocalization.of(context)!.translate(TranslationString.canNotBeEmpty)}'; // Error message
            }
            return null;
          },
        ),
        SizedBox(
          height: 3.w,
        ),
        CustomTextField(
          controller: selectedBuildingArea,
          label: AppLocalization.of(context)!
              .translate(TranslationString.buildingUsageArea),
          hintText: AppLocalization.of(context)!
              .translate(TranslationString.buildingUsageArea),
          inputType: TextInputType.number,
          horizontalSpacing: 0,
          verticalSpacing: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '${AppLocalization.of(context)!.translate(TranslationString.buildingUsageArea)} ${AppLocalization.of(context)!.translate(TranslationString.canNotBeEmpty)}'; // Error message
            }
            return null;
          },
        ),
        SizedBox(
          height: 3.w,
        ),
        CustomTextField(
          controller: selectedBuildableArea,
          label: AppLocalization.of(context)!
              .translate(TranslationString.buildableAreaInM2),
          hintText: AppLocalization.of(context)!
              .translate(TranslationString.buildableAreaInM2),
          inputType: TextInputType.number,
          horizontalSpacing: 0,
          verticalSpacing: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '${AppLocalization.of(context)!.translate(TranslationString.buildableAreaInM2)} ${AppLocalization.of(context)!.translate(TranslationString.canNotBeEmpty)}'; // Error message
            }
            return null;
          },
        ),
        SizedBox(
          height: 10.w,
        ),
        sliderSelections(),
        SizedBox(
          height: 10.w,
        ),
        questionText(AppLocalization.of(context)!
            .translate(TranslationString.furnished)),
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
        questionText(
            AppLocalization.of(context)!.translate(TranslationString.garage)),
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
                  questionText(AppLocalization.of(context)!
                      .translate(TranslationString.addPictures)),
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
          onTap:
              widget.isEditingEnabled == true ? updateProperty : onSendRequest,
          child: CustomButton(
            text: widget.isEditingEnabled == true
                ? AppLocalization.of(context)!
                    .translate(TranslationString.update)
                : AppLocalization.of(context)!
                    .translate(TranslationString.post),
          ),
        ),
      ],
    );
  }

  Widget imagesContainer(BuildContext context) {
    List<String> allImages = [...existingImages, ...images]; // Combine lists

    return allImages.isNotEmpty
        ? LayoutBuilder(
            builder: (context, constraints) {
              int rows = (allImages.length / 3).ceil();
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
                  itemCount: allImages.length,
                  itemBuilder: (context, index) {
                    bool isExistingImage = index < existingImages.length;

                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: isExistingImage
                              ? Image.network(
                                  existingImages[
                                      index], // Show URL images first
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                              : Image.file(
                                  File(images[index -
                                      existingImages
                                          .length]), // Show local images after
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
                                if (isExistingImage) {
                                  existingImages
                                      .removeAt(index); // Remove URL image
                                } else {
                                  images.removeAt(index -
                                      existingImages
                                          .length); // Remove local image
                                }
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
        : Center(
            child: Text(AppLocalization.of(context)!
                .translate(TranslationString.noImageSelected)),
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
            questionText(AppLocalization.of(context)!
                .translate(TranslationString.rooms)),
            SizedBox(
              width: 6.w,
            ),
          ],
        ),
        // SfSlider(
        //   min: 0.0,
        //   max: 50.0,
        //   value: beds,
        //   interval: 1.0,
        //   showLabels: false,
        //   enableTooltip: true,
        //   minorTicksPerInterval: 1,
        //   activeColor: AppColors.blue,
        //   inactiveColor: AppColors.lightGrey,
        //   tooltipShape: const SfPaddleTooltipShape(),
        //   onChanged: (value) {
        //     setState(() {
        //       beds = value.toInt();
        //     });
        //   },
        // ),
        CustomTextField(
          controller: bedsController,
          label:
              AppLocalization.of(context)!.translate(TranslationString.rooms),
          hintText:
              AppLocalization.of(context)!.translate(TranslationString.rooms),
          inputType: TextInputType.number,
          horizontalSpacing: 0,
          verticalSpacing: 10,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '${AppLocalization.of(context)!.translate(TranslationString.rooms)} ${AppLocalization.of(context)!.translate(TranslationString.canNotBeEmpty)}'; // Error message
            }
            return null;
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
            questionText(AppLocalization.of(context)!
                .translate(TranslationString.bathrooms)),
            SizedBox(
              width: 6.w,
            ),
          ],
        ),
        // SfSlider(
        //   min: 0.0,
        //   max: 50.0,
        //   value: bathroom,
        //   interval: 1.0,
        //   showLabels: false,
        //   enableTooltip: true,
        //   minorTicksPerInterval: 1,
        //   activeColor: AppColors.blue,
        //   inactiveColor: AppColors.lightGrey,
        //   tooltipShape: const SfPaddleTooltipShape(),
        //   onChanged: (value) {
        //     setState(() {
        //       bathroom = value.toInt();
        //     });
        //   },
        // ),
        CustomTextField(
          controller: bathsController,
          label: AppLocalization.of(context)!
              .translate(TranslationString.bathrooms),
          hintText: AppLocalization.of(context)!
              .translate(TranslationString.bathrooms),
          inputType: TextInputType.number,
          horizontalSpacing: 0,
          verticalSpacing: 10,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '${AppLocalization.of(context)!.translate(TranslationString.bathrooms)} ${AppLocalization.of(context)!.translate(TranslationString.canNotBeEmpty)}'; // Error message
            }
            return null;
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
            questionText(AppLocalization.of(context)!
                .translate(TranslationString.price)),
            SizedBox(
              width: 6.w,
            ),
          ],
        ),
        // SfSlider(
        //   min: 0.0,
        //   max: 100000000.0,
        //   value: price,
        //   interval: 100000.0,
        //   showLabels: false,
        //   enableTooltip: true,
        //   minorTicksPerInterval: 1000,
        //   activeColor: AppColors.blue,
        //   inactiveColor: AppColors.lightGrey,
        //   tooltipShape: const SfPaddleTooltipShape(),
        //   numberFormat:
        //       NumberFormat.simpleCurrency(locale: 'de_DE', decimalDigits: 0),
        //   onChanged: (value) {
        //     setState(() {
        //       price = value.toInt();
        //     });
        //   },
        // ),
        CustomTextField(
          controller: priceController,
          label:
              AppLocalization.of(context)!.translate(TranslationString.price),
          hintText:
              AppLocalization.of(context)!.translate(TranslationString.price),
          inputType: TextInputType.number,
          horizontalSpacing: 0,
          verticalSpacing: 10,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '${AppLocalization.of(context)!.translate(TranslationString.price)} ${AppLocalization.of(context)!.translate(TranslationString.canNotBeEmpty)}'; // Error message
            }
            return null;
          },
        ),
      ],
    );
  }
}
