import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stargate/config/core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/utils/app_enums.dart';
import 'package:stargate/widgets/buttons/custom_button.dart';
import 'package:stargate/widgets/buttons/custom_tab_button.dart';
import 'package:stargate/widgets/buttons/filter_button.dart';
import 'package:stargate/widgets/cards/listing_card.dart';
import 'package:stargate/widgets/inputfields/country_textfield.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  UserType selectedUser = UserType.investor;
  List<String> items = [
    'Mahnoor Hashmi',
    'lara Willson',
    'johnson',
    'Braid Pitt',
  ];
  List<UserType> userTypes = [
    UserType.investor,
    UserType.agent,
    UserType.lawyer,
    UserType.notary,
    UserType.appraiser,
  ];
  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  List<String> cities = [];

  List<String> experience = [
    'All',
    '5 years above',
    '5 years',
    'below 5 years'
  ];
  String selectedExperience = '';
  bool filterApplied = false;
  void resetFilters() {
    setState(() {
      country.clear();
      state.clear();
      city.clear();
      selectedExperience = '';
      filterApplied = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Search",
          style: AppStyles.heading3,
        ),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(10.w),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                ...userTypes.map(
                  (type) => CustomTabButton(
                    type: type.toString().split('.').last,
                    current: selectedUser.toString().split('.').last,
                    selected: (value) {
                      setState(() {
                        selectedUser = UserType.values.firstWhere(
                            (e) => e.toString().split('.').last == value);
                      });
                    },
                  ),
                ),
              ]),
            ),
            SizedBox(
              height: 6.w,
            ),
            SingleChildScrollView(
              child: StaggeredGrid.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8.w,
                mainAxisSpacing: 8.w,
                children: List.generate(items.length + 1, (index) {
                  if (index == 1) {
                    return FilterButton(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return bottomSheetContent();
                          },
                        );
                      },
                    );
                  } else {
                    int itemIndex = index > 1 ? index - 1 : index;
                    return ListingCard(
                      imageURl:
                          'https://images.stockcake.com/public/0/3/1/0316b537-d898-429c-8d78-099e7df7a140_large/masked-urban-individual-stockcake.jpg',
                      title: items[itemIndex],
                      subtitle: items[itemIndex],
                      isVerified: true,
                    );
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomSheetContent() {
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
                "Experience",
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
                    ...experience.map(
                      (e) => CustomTabButton(
                        type: e,
                        selected: (value) {
                          setState(() {
                            selectedExperience = value;
                          });
                        },
                        current: selectedExperience,
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
                  if (country.text.isNotEmpty || selectedExperience != '') {
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
