import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stargate/models/user.dart';
import 'package:stargate/utils/app_data.dart';
import 'package:stargate/widgets/buttons/custom_button.dart';
import 'package:stargate/widgets/buttons/custom_tab_button.dart';
import 'package:stargate/widgets/buttons/filter_button.dart';
import 'package:stargate/widgets/inputfields/country_textfield.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stargate/screens/services_screen/widgets/user_listing_card.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/utils/app_enums.dart';

import '../../providers/service_providers_provider.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  UserType selectedUser = UserType.investor;
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
  String selectedExperience = '';
  bool filterApplied = false;
  List<User> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    Provider.of<AllUsersProvider>(context, listen: false).fetchUsers();
  }

  List<User> filterUsersByType(List<User> users, UserType selectedType) {
    return users
        .where((user) => user.containsServiceUserType(selectedType))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final allUsersProvider = Provider.of<AllUsersProvider>(context);

    if (!filterApplied) {
      filteredUsers = filterUsersByType(allUsersProvider.users, selectedUser);
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Search",
          style: AppStyles.heading3.copyWith(
            color: AppColors.darkBlue,
          ),
        ),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(10.w),
        child: allUsersProvider.loading
            ? const Center(child: CircularProgressIndicator())
            : allUsersProvider.noUsers
                ? const Center(child: Text("No users found"))
                : Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ...userTypes.map(
                              (type) => CustomTabButton(
                                type: type.toString().split('.').last,
                                current:
                                    selectedUser.toString().split('.').last,
                                selected: (value) {
                                  setState(() {
                                    selectedUser = UserType.values.firstWhere(
                                        (e) =>
                                            e.toString().split('.').last ==
                                            value);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 6.w),
                      filteredUsers.isNotEmpty
                          ? Expanded(
                              child: SingleChildScrollView(
                                child: StaggeredGrid.count(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8.w,
                                  mainAxisSpacing: 8.w,
                                  children: List.generate(
                                      filteredUsers.length + 1, (index) {
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
                                      int itemIndex =
                                          index > 1 ? index - 1 : index;
                                      return ServiceProviderListingCard(
                                          user: filteredUsers[itemIndex]);
                                    }
                                  }),
                                ),
                              ),
                            )
                          : const Expanded(
                              child: Center(
                                  child: Text(
                                "No users under selected category",
                                style: AppStyles.supportiveText,
                              )),
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
                SizedBox(height: 12.w),
                Text(
                  "Experience",
                  style: AppStyles.normalText.copyWith(
                    color: AppColors.primaryGrey,
                  ),
                ),
                SizedBox(height: 6.w),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...experiencesList.map(
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
                      applyFilters();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void resetFilters() {
    setState(() {
      country.clear();
      state.clear();
      city.clear();
      selectedExperience = '';
      filterApplied = false;
      filteredUsers = filterUsersByType(
          Provider.of<AllUsersProvider>(context, listen: false).users,
          selectedUser);
    });
  }

  void applyFilters() {
    AllUsersProvider.c(context)
        .filterUsers(country.text, city.text, selectedExperience, selectedUser);
  }
}
