import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stargate/config/core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/screens/home/widgets/property_card.dart';
import 'package:stargate/screens/property_request_screen/property_request_screen.dart';
import 'package:stargate/utils/app_images.dart';
import 'package:stargate/widgets/loader/loader.dart';
import 'package:stargate/widgets/screen/screen.dart';

import '../../cubit/real_estate_listing/cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getListing();
    });
  }

  void getListing() async {
    RealEstateListingsCubit cubit =
        BlocProvider.of<RealEstateListingsCubit>(context);
    try {
      await cubit.getAllRealEstateListings();
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      overlayWidgets: [
        if (loading)
          const FullScreenLoader(
            loading: true,
          )
      ],
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: BlocListener<RealEstateListingsCubit, RealEstateListingsState>(
          listener: (context, state) {
            // Manage loading state based on Bloc state changes
            if (state is GetAllRealEstateListingsLoading &&
                state.listings.isEmpty) {
              setState(() {
                loading = true;
              });
            } else {
              setState(() {
                loading = false;
              });
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 180,
                      width: double.infinity,
                      color: AppColors.darkBlue,
                    ),
                    SizedBox(
                      child: BlocBuilder<RealEstateListingsCubit,
                          RealEstateListingsState>(builder: (context, state) {
                        if (state is GetAllRealEstateListingsLoading &&
                            state.listings.isNotEmpty) {
                          return Container(
                            margin: EdgeInsets.only(top: 60.w),
                            height: 240.w,
                            child: CarouselSlider(
                              options: CarouselOptions(
                                height: 240.h,
                                autoPlay: false,
                                enlargeCenterPage: false,
                                viewportFraction:
                                    state.listings.length == 1 ? 1 : 0.5,
                                enableInfiniteScroll: false,
                                padEnds: false,
                              ),
                              items: List.generate(
                                  state.listings.length < 3
                                      ? state.listings.length
                                      : 3, (index) {
                                return PropertyCardHome(
                                    property: state.listings[index]);
                              }),
                            ),
                          );
                        } else if (state is GetAllRealEstateListingsFailure) {
                          return Center(child: Text(state.errorMessage));
                        } else if (state is GetAllRealEstateListingsSuccess) {
                          return state.listings.isEmpty
                              ? const SizedBox()
                              : Container(
                                  margin: EdgeInsets.only(top: 60.w),
                                  height: 240.w,
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                      height: 240.h,
                                      autoPlay: false,
                                      enlargeCenterPage: false,
                                      viewportFraction:
                                          state.listings.length == 1 ? 1 : 0.5,
                                      enableInfiniteScroll: false,
                                      padEnds: false,
                                    ),
                                    items: List.generate(
                                        state.listings.length < 3
                                            ? state.listings.length
                                            : 3, (index) {
                                      return PropertyCardHome(
                                          property: state.listings[index]);
                                    }),
                                  ),
                                );
                        } else {
                          return const SizedBox();
                        }
                      }),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 150.w,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 12.w),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10.w),
                          boxShadow: [
                            AppStyles.boxShadow,
                          ],
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              AppImages.sale,
                              width: MediaQuery.of(context).size.width * 0.25,
                            ),
                            SizedBox(
                              width: 12.w,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.55,
                                  child: Text(
                                    "Do you want to sale property or request it?",
                                    style: AppStyles.heading3.copyWith(
                                      color: AppColors.darkBlue,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  height: 8.w,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: const Text(
                                    "sale/ rent your property at best price",
                                    style: AppStyles.supportiveText,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  height: 8.w,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final result = await Navigator.of(context,
                                            rootNavigator: false)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const PropertyRequestForm(),
                                      ),
                                    );
                                    if (result == 'success') {
                                      getListing();
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Create Offer",
                                        style: AppStyles.heading4.copyWith(
                                            color: AppColors.darkBlue),
                                      ),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      const Icon(
                                        Icons.arrow_forward,
                                        color: AppColors.darkBlue,
                                        size: 18,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
