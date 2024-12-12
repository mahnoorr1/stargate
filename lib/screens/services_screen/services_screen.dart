import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stargate/models/user.dart';
import 'package:stargate/utils/app_data.dart';
import 'package:stargate/widgets/buttons/custom_button.dart';
import 'package:stargate/widgets/buttons/custom_tab_button.dart';
import 'package:stargate/widgets/buttons/filter_button.dart';
import 'package:stargate/widgets/custom_toast.dart';
import 'package:stargate/widgets/inputfields/country_textfield.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stargate/screens/services_screen/widgets/user_listing_card.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/utils/app_enums.dart';

import '../../localization/localization.dart';
import '../../localization/translation_strings.dart';
import '../../providers/service_providers_provider.dart';
import '../../providers/user_info_provider.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  UserType selectedUser = UserType.all;
  List<UserType> userTypes = [];
  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  String selectedExperience = '';
  bool filterApplied = false;

  @override
  void initState() {
    super.initState();
    Provider.of<AllUsersProvider>(context, listen: false).fetchUsers();

    String membership = UserProfileProvider.c(context).membership;
    if (membership == "66c2ff151bf7b7176ee92708" ||
        membership == '66c2ff461bf7b7176ee92713') {
      userTypes = [
        UserType.consultant,
        UserType.lawyer,
        UserType.notary,
        UserType.appraiser,
        UserType.manager,
        UserType.economist,
        UserType.drawingMaker,
        UserType.propertyAdmin,
      ];
    } else if (membership == '66c2ff151bf7b7176ee92722') {
      userTypes = [
        UserType.consultant,
        UserType.lawyer,
        UserType.notary,
        UserType.appraiser,
        UserType.manager,
        UserType.economist,
        UserType.drawingMaker,
        UserType.propertyAdmin,
        UserType.investor,
      ];
    } else {
      userTypes = [
        UserType.all,
        UserType.investor,
        UserType.agent,
        UserType.consultant,
        UserType.lawyer,
        UserType.notary,
        UserType.appraiser,
        UserType.manager,
        UserType.loanBroker,
        UserType.economist,
        UserType.drawingMaker,
        UserType.propertyAdmin,
      ];
    }
    selectedUser = userTypes[0];
  }

  void resetFilters() {
    setState(() {
      country.clear();
      state.clear();
      city.clear();
      selectedExperience = '';
      filterApplied = false;
    });
  }

  final List<Map<String, String>> userMapping = [
    {'type': UserType.all.name, 'label': TranslationString.all},
    {'type': UserType.investor.name, 'label': TranslationString.investor},
    {'type': UserType.agent.name, 'label': TranslationString.agent},
    {'type': UserType.consultant.name, 'label': TranslationString.consultant},
    {'type': UserType.lawyer.name, 'label': TranslationString.lawyer},
    {'type': UserType.notary.name, 'label': TranslationString.notary},
    {'type': UserType.appraiser.name, 'label': TranslationString.appraiser},
    {'type': UserType.manager.name, 'label': TranslationString.manager},
    {'type': UserType.loanBroker.name, 'label': TranslationString.loanBroker},
    {'type': UserType.economist.name, 'label': TranslationString.economist},
    {
      'type': UserType.drawingMaker.name,
      'label': TranslationString.drawingMaker
    },
    {
      'type': UserType.propertyAdmin.name,
      'label': TranslationString.propertyAdmin
    },
  ];
  @override
  Widget build(BuildContext context) {
    final allUsersProvider = Provider.of<AllUsersProvider>(context);

    final currentUserId = UserProfileProvider.c(context).id;

    List<User> displayedUsers = selectedUser == UserType.all
        ? allUsersProvider.filteredUsers
            .where((user) => user.id != currentUserId)
            .toList()
        : allUsersProvider.filteredUsers
            .where((user) =>
                user.id != currentUserId &&
                user.containsServiceUserType(selectedUser))
            .toList();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          AppLocalization.of(context)!.translate(TranslationString.search),
          style: AppStyles.heading3.copyWith(color: AppColors.darkBlue),
        ),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(10.w),
        child: allUsersProvider.loading
            ? const Center(child: CircularProgressIndicator())
            : (allUsersProvider.noUsers && !filterApplied)
                ? Center(
                    child: Text(AppLocalization.of(context)!
                        .translate(TranslationString.noUsersFound)))
                : Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: userMapping.map((user) {
                            final localizedLabel = AppLocalization.of(context)
                                    ?.translate(user['label']!) ??
                                user['label']!;

                            return CustomTabButton(
                              type: localizedLabel, // Ensure non-null value
                              current: AppLocalization.of(context)?.translate(
                                      userMapping.firstWhere((u) =>
                                          u['type'] ==
                                          selectedUser.name)['label']!) ??
                                  userMapping.firstWhere((u) =>
                                      u['type'] == selectedUser.name)['label']!,
                              selected: (value) {
                                final selected = userMapping.firstWhere(
                                  (u) =>
                                      AppLocalization.of(context)
                                          ?.translate(u['label']!) ==
                                      value,
                                );
                                setState(() {
                                  selectedUser = UserType.values.firstWhere(
                                    (e) => e.name == selected['type'],
                                  );
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 6.w),
                      displayedUsers.isNotEmpty
                          ? Expanded(
                              child: SingleChildScrollView(
                                child: StaggeredGrid.count(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8.w,
                                  mainAxisSpacing: 8.w,
                                  children: List.generate(
                                      displayedUsers.length + 1, (index) {
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
                                          user: displayedUsers[itemIndex]);
                                    }
                                  }),
                                ),
                              ),
                            )
                          : Expanded(
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      child: FilterButton(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return bottomSheetContent();
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.6,
                                    child: Center(
                                      child: Text(AppLocalization.of(context)!
                                          .translate(TranslationString
                                              .noUsersAvailableOnFilter)),
                                    ),
                                  ),
                                ],
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
                Text(
                    AppLocalization.of(context)!.translate(TranslationString
                        .applySearchFiltersForServiceProviders),
                    style: AppStyles.heading4),
                SizedBox(height: 12.h),
                filterApplied
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            filterApplied = false;
                          });
                          AllUsersProvider.c(context).resetFilters();
                          resetFilters();
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            AppLocalization.of(context)!
                                .translate(TranslationString.clearFilters),
                            style: AppStyles.heading4
                                .copyWith(color: AppColors.blue),
                          ),
                        ),
                      )
                    : const SizedBox(),
                CountryPickerField(country: country, state: state, city: city),
                SizedBox(height: 12.w),
                Text(
                    AppLocalization.of(context)!
                        .translate(TranslationString.experience),
                    style: AppStyles.normalText
                        .copyWith(color: AppColors.primaryGrey)),
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
                  text: AppLocalization.of(context)!
                      .translate(TranslationString.applyFilters),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      filterApplied = true;
                    });
                    AllUsersProvider.c(context).filterUsers(
                      country.text,
                      city.text,
                      selectedExperience,
                      selectedUser,
                    );
                    if (AllUsersProvider.c(context).filteredUsers.isEmpty) {
                      showToast(
                        message: AppLocalization.of(context)!.translate(
                            TranslationString.noUsersAvailableOnFilter),
                        context: context,
                        isAlert: true,
                      );
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
}
