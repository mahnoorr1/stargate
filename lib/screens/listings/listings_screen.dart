import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:stargate/config/core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/content_management/providers/listing_content_provider.dart';
import 'package:stargate/localization/translation_strings.dart';
import 'package:stargate/screens/listings/widgets/dropdown_button2.dart';
import 'package:stargate/screens/listings/widgets/listing_card.dart';
import 'package:stargate/utils/app_data.dart';
import 'package:stargate/widgets/buttons/custom_button.dart';
import 'package:stargate/widgets/buttons/custom_tab_button.dart';
import 'package:stargate/widgets/buttons/filter_button.dart';
import 'package:stargate/widgets/custom_toast.dart';
import 'package:stargate/widgets/inputfields/country_textfield.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import '../../localization/localization.dart';
import '../../providers/real_estate_provider.dart';
import '../../widgets/inputfields/outlined_dropdown.dart';

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
  SfRangeValues _priceRange = const SfRangeValues(0.0, 100000000.0);
  String selectedPropertyType = '';
  String selectedPropertyCategory = '';
  String selectedPropertySubcategory = '';
  String selectedRequestType = '';
  String selectedCondition = '';
  String selectedSellingType = '';
  List<String> currentSubcategoryOptions = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RealEstateProvider.c(context).fetchAllListings(initialLoad: true);
    });
  }

  void resetFilters() {
    setState(() {
      filterApplied = false;
      country.clear();
      state.clear();
      city.clear();
      selectedPropertyType = '';
      selectedPropertyCategory = '';
      selectedPropertySubcategory = '';
      selectedRequestType = '';
      selectedCondition = '';
      selectedSellingType = '';
    });
    RealEstateProvider.c(
      context,
    ).resetFilters();
  }

  void showNoPropertiesToast() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showToast(
        message: AppLocalization.of(context)!
            .translate(TranslationString.noPropertiesFoundForFilters),
        context: context,
        isAlert: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    currentSubcategoryOptions = [
      AppLocalization.of(context)!.translate(TranslationString.selectOption)
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalization.of(context)!
              .translate(TranslationString.realEstateListings),
          style: AppStyles.heading3.copyWith(
            color: AppColors.darkBlue,
          ),
        ),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(10.w),
        child: Consumer<RealEstateProvider>(
          builder: (context, provider, child) {
            if (provider.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (provider.noListings && !filterApplied) {
              return Center(
                  child: Text(AppLocalization.of(context)!.translate(
                      TranslationString.noPropertyListingAvailable)));
            } else if (provider.noListings && filterApplied) {
              showNoPropertiesToast();
              RealEstateProvider.c(
                context,
              ).resetFilters();
              return buildContent(provider);
            } else {
              return buildContent(provider);
            }
          },
        ),
      ),
    );
  }

  Widget buildContent(RealEstateProvider provider) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: StaggeredGrid.count(
              crossAxisCount: 2,
              crossAxisSpacing: 8.w,
              mainAxisSpacing: 8.w,
              children: List.generate(provider.filteredProperties.length + 1,
                  (index) {
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
                    listing: provider.filteredProperties[itemIndex],
                  );
                }
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomSheet() {
    final listingContentProvider =
        Provider.of<ListingContentProvider>(context, listen: false);
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
                Text(
                  listingContentProvider.listingContent!.searchFilterTagLine,
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
                            AppLocalization.of(context)!
                                .translate(TranslationString.clearFilters),
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
                SizedBox(height: 12.w),
                Text(
                  AppLocalization.of(context)!
                      .translate(TranslationString.priceRange),
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
                  AppLocalization.of(context)!
                      .translate(TranslationString.propertyType),
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
                              selectedPropertyCategory = '';
                              selectedPropertySubcategory = '';
                              currentSubcategoryOptions = [
                                AppLocalization.of(context)!
                                    .translate(TranslationString.selectOption)
                              ];
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
                            AppLocalization.of(context)!
                                .translate(TranslationString.investmentType),
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
                                      int selectedCategoryIndex =
                                          commercialPropertyCategory
                                              .indexOf(value);
                                      currentSubcategoryOptions =
                                          commercialPropertySubcategory[
                                              selectedCategoryIndex];
                                      selectedPropertySubcategory =
                                          currentSubcategoryOptions[0];
                                    });
                                  },
                                  initial: commercialPropertyCategory[0],
                                  label: AppLocalization.of(context)!.translate(
                                      TranslationString.selectInvestmentType),
                                )
                              : DropdownButton2Example(
                                  list: conventionalPropertyCategory,
                                  onSelected: (value) {
                                    setState(() {
                                      selectedPropertyCategory = value;
                                      int selectedCategoryIndex =
                                          conventionalPropertyCategory
                                              .indexOf(value);
                                      currentSubcategoryOptions =
                                          conventionalPropertySubcategory[
                                              selectedCategoryIndex];
                                      selectedPropertySubcategory =
                                          currentSubcategoryOptions[0];
                                    });
                                  },
                                  initial: conventionalPropertyCategory[0],
                                  label: AppLocalization.of(context)!.translate(
                                      TranslationString.selectInvestmentType),
                                ),
                          SizedBox(
                            height: 10.w,
                          ),
                          Text(
                            AppLocalization.of(context)!.translate(
                                TranslationString.investmentSubcategory),
                            style: AppStyles.normalText.copyWith(
                              color: AppColors.primaryGrey,
                            ),
                          ),
                          SizedBox(
                            height: 6.w,
                          ),
                          selectedPropertyType == 'commercial'
                              ? OutlinedDropdownButtonExample(
                                  list: currentSubcategoryOptions,
                                  onSelected: (value) {
                                    setState(() {
                                      selectedPropertySubcategory = value;
                                    });
                                  },
                                  initial:
                                      selectedPropertySubcategory.isNotEmpty
                                          ? selectedPropertySubcategory
                                          : currentSubcategoryOptions[0],
                                  label: AppLocalization.of(context)!.translate(
                                      TranslationString.selectSubcategory),
                                )
                              : DropdownButton2Example(
                                  list: currentSubcategoryOptions,
                                  onSelected: (value) {
                                    setState(() {
                                      selectedPropertySubcategory = value;
                                    });
                                  },
                                  initial:
                                      selectedPropertySubcategory.isNotEmpty
                                          ? selectedPropertySubcategory
                                          : currentSubcategoryOptions[0],
                                  label: AppLocalization.of(context)!.translate(
                                      TranslationString.selectSubcategory),
                                ),
                        ],
                      ),
                SizedBox(
                  height: 10.w,
                ),
                Text(
                  AppLocalization.of(context)!
                      .translate(TranslationString.purchase),
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
                  AppLocalization.of(context)!
                      .translate(TranslationString.conditionCapital),
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
                  AppLocalization.of(context)!
                      .translate(TranslationString.searchingFor),
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
                  text: AppLocalization.of(context)!
                      .translate(TranslationString.applyFilters),
                  onPressed: () {
                    setState(() {
                      filterApplied = true;
                    });
                    RealEstateProvider.c(context, false).filterProperties(
                        country: country.text,
                        city: city.text,
                        condition: selectedCondition,
                        investmentType: selectedPropertyCategory,
                        investmentSubcategory: selectedPropertySubcategory,
                        offerType: selectedRequestType,
                        purchaseType: selectedSellingType,
                        propertyType: selectedPropertyType,
                        priceRange:
                            "${_priceRange.start.toInt()},${_priceRange.end.toInt()}");
                    setState(() {
                      filterApplied = true;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
