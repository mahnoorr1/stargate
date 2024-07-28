import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:stargate/config/core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/screens/listings/widgets/dropdown_button2.dart';
import 'package:stargate/screens/listings/widgets/listing_card.dart';
import 'package:stargate/utils/app_data.dart';
import 'package:stargate/widgets/buttons/custom_button.dart';
import 'package:stargate/widgets/buttons/custom_tab_button.dart';
import 'package:stargate/widgets/buttons/filter_button.dart';
import 'package:stargate/widgets/inputfields/country_textfield.dart';
import 'package:stargate/widgets/inputfields/outlined_dropdown.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class ListingsScreen extends StatefulWidget {
  const ListingsScreen({super.key});

  @override
  State<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  bool filterApplied = false;
  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  void resetFilters() {
    setState(() {
      country.clear();
      state.clear();
      city.clear();
      selectedCondition = '';
      selectedPropertyCategory = '';
      selectedPropertySubcategory = '';
      selectedPropertyType = '';
      selectedRequestType = '';
      selectedSellingType = '';
      filterApplied = false;
    });
  }

  SfRangeValues _priceRange = const SfRangeValues(0.0, 100000000.0);
  String selectedPropertyType = '';
  String selectedPropertyCategory = '';
  String selectedPropertySubcategory = '';
  String selectedRequestType = '';
  String selectedCondition = '';
  String selectedSellingType = '';
  List<String> categoryList() {
    if (selectedPropertyCategory == 'commercial') {
      return commercialPropertyCategory;
    }
    return conventionalPropertyCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Real Estate Listings",
          style: AppStyles.heading3.copyWith(
            color: AppColors.darkBlue,
          ),
        ),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(10.w),
        child: SingleChildScrollView(
          child: StaggeredGrid.count(
            crossAxisCount: 2,
            crossAxisSpacing: 8.w,
            mainAxisSpacing: 8.w,
            children: List.generate(listings.length + 1, (index) {
              if (index == 1) {
                return FilterButton(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return bottomSheet();
                      },
                    );
                  },
                );
              } else {
                int itemIndex = index > 1 ? index - 1 : index;
                return ListingCard(
                  listing: listings[itemIndex],
                );
              }
            }),
          ),
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.w),
              topRight: Radius.circular(20.w),
            ),
            color: AppColors.backgroundColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Apply search filters for Service Providers',
                style: AppStyles.heading4,
              ),
              SizedBox(height: 12.h),
              filterApplied
                  ? GestureDetector(
                      onTap: () {
                        resetFilters();
                        setState(() {});
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "clear filters",
                          style: AppStyles.heading4.copyWith(
                            color: AppColors.blue,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              CountryPickerField(
                country: country,
                state: state,
                city: city,
              ),
              SizedBox(
                height: 12.w,
              ),
              Text(
                "Price Range",
                style: AppStyles.normalText.copyWith(
                  color: AppColors.primaryGrey,
                ),
              ),
              SizedBox(
                height: 6.w,
              ),
              SfRangeSlider(
                min: 0.0,
                max: 100000000.0,
                values: _priceRange,
                interval: 10000000.0,
                showTicks: true,
                showLabels: false,
                enableTooltip: true,
                minorTicksPerInterval: 1,
                activeColor: AppColors.blue,
                inactiveColor: AppColors.lightGrey,
                tooltipShape: const SfPaddleTooltipShape(),
                numberFormat: NumberFormat.simpleCurrency(
                    locale: 'de_DE', decimalDigits: 0),
                onChanged: (SfRangeValues newRange) {
                  setState(() {
                    _priceRange = newRange;
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('€0'),
                    Text('€100 000 000'),
                  ],
                ),
              ),
              SizedBox(
                height: 10.w,
              ),
              Text(
                "Property Type",
                style: AppStyles.normalText.copyWith(
                  color: AppColors.primaryGrey,
                ),
              ),
              SizedBox(
                height: 6.w,
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
                  ? const SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10.w,
                        ),
                        Text(
                          "Investment Type",
                          style: AppStyles.normalText.copyWith(
                            color: AppColors.primaryGrey,
                          ),
                        ),
                        SizedBox(
                          height: 6.w,
                        ),
                        selectedPropertyType == 'commercial'
                            ? OutlinedDropdownButtonExample(
                                list: commercialPropertyCategory,
                                onSelected: (value) {
                                  setState(() {
                                    selectedPropertyCategory = value;
                                  });
                                },
                                initial: commercialPropertyCategory[0],
                                label: 'Select Investment Type',
                              )
                            : DropdownButton2Example(
                                list: conventionalPropertyCategory,
                                onSelected: (value) {
                                  setState(() {
                                    selectedPropertyCategory = value;
                                  });
                                },
                                initial: conventionalPropertyCategory[0],
                                label: 'Select Investment Type',
                              ),
                        SizedBox(
                          height: 10.w,
                        ),
                        Text(
                          "Investment Subcategory",
                          style: AppStyles.normalText.copyWith(
                            color: AppColors.primaryGrey,
                          ),
                        ),
                        SizedBox(
                          height: 6.w,
                        ),
                        selectedPropertyType == 'commercial'
                            ? OutlinedDropdownButtonExample(
                                list: commercialPropertySubcategory,
                                onSelected: (value) {
                                  setState(() {
                                    selectedPropertySubcategory = value;
                                  });
                                },
                                initial: commercialPropertySubcategory[0],
                                label: 'Select Investment Subcategory',
                              )
                            : DropdownButton2Example(
                                list: conventionalPropertySubcategory,
                                onSelected: (value) {
                                  setState(() {
                                    selectedPropertyCategory = value;
                                  });
                                },
                                initial: conventionalPropertySubcategory[0],
                                label: 'Select Investment Type',
                              ),
                      ],
                    ),
              SizedBox(
                height: 10.w,
              ),
              Text(
                "Purchase",
                style: AppStyles.normalText.copyWith(
                  color: AppColors.primaryGrey,
                ),
              ),
              SizedBox(
                height: 6.w,
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
                            selectedSellingType = value;
                          });
                        },
                        current: selectedSellingType,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.w,
              ),
              Text(
                "Condition",
                style: AppStyles.normalText.copyWith(
                  color: AppColors.primaryGrey,
                ),
              ),
              SizedBox(
                height: 6.w,
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
                height: 10.w,
              ),
              Text(
                "Searching for",
                style: AppStyles.normalText.copyWith(
                  color: AppColors.primaryGrey,
                ),
              ),
              SizedBox(
                height: 6.w,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...requestType.map(
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
              SizedBox(height: 20.h),
              CustomButton(
                text: 'Apply Filters',
                onPressed: () {
                  Navigator.pop(context);
                  if (country.text.isNotEmpty ||
                      selectedCondition != '' ||
                      selectedPropertyCategory == '' ||
                      selectedPropertySubcategory == '' ||
                      selectedPropertyType == '') {
                    setState(() {
                      filterApplied = true;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
