import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/cubit/service_providers/cubit.dart';
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
  List<User> allUsers = [];
  List<User> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  Future<void> getUsers() async {
    AllUsersCubit cubit = BlocProvider.of<AllUsersCubit>(context);
    try {
      await cubit.getAllUsers();
      // // Listen to the users from the state
      // cubit.stream.listen((state) {
      //   if (state is GetAllUsersSuccess) {
      //     // setState(() {
      //     allUsers = state.users;
      //     filterUsersByType(users, UserType.investor);
      //     // });
      //   }
      // });
    } catch (e) {
      // Handle error
    }
  }

  List<User> filterUsersByType(List<User> users, UserType selectedType) {
    return users
        .where((user) => user.containsServiceUserType(selectedType))
        .toList();
  }

  Future<void> filterUsers() async {
    AllUsersCubit cubit = BlocProvider.of<AllUsersCubit>(context);
    try {
      print("entered filters");
      await cubit.filterUsers();
      // cubit.stream.listen((state) {
      //   if (state is GetFilteredUsersSuccess) {
      //     setState(() {
      //       allUsers = state.filteredUsers;
      //       filterUsersByType(users, UserType.investor);
      //     });
      //   }
      // });
    } catch (e) {
      print(e.toString());
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AllUsersCubit>();
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
        child: BlocBuilder<AllUsersCubit, AllUsersState>(
          bloc: cubit,
          builder: (context, state) {
            if (!filterApplied) {
              if (state is GetAllUsersInitial) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GetAllUsersLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GetAllUsersSuccess) {
                final users = state.users;

                filteredUsers = filterUsersByType(users, selectedUser);
              } else {
                if (state is GetFilteredUsersInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GetFilteredUsersLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GetFilteredUsersSuccess) {
                  final users = state.filteredUsers;

                  filteredUsers = filterUsersByType(users, selectedUser);
                }
              }

              // Filter users based on the selected user type

              return Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...userTypes.map(
                          (type) => CustomTabButton(
                            type: type.toString().split('.').last,
                            current: selectedUser.toString().split('.').last,
                            selected: (value) {
                              setState(() {
                                selectedUser = UserType.values.firstWhere((e) =>
                                    e.toString().split('.').last == value);
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
                              children: List.generate(filteredUsers.length + 1,
                                  (index) {
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
              );
            } else if (state is GetAllUsersFailure) {
              return Center(
                child: Text(state.errorMessage),
              );
            } else {
              return const Text('Unexpected state'); // Handle unexpected states
            }
          },
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
                      filterUsers();
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
      // Optionally reset the filtered users to show all users again
      filteredUsers = filterUsersByType(allUsers, selectedUser);
    });
  }
}
