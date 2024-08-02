import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/models/user.dart';
import 'package:stargate/screens/profile/widgets/post_card.dart';
import 'package:stargate/utils/app_data.dart';
import 'package:stargate/widgets/buttons/membership_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User user = users[0];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30.w),
                        bottomRight: Radius.circular(30.w),
                      ),
                      child: Image(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.45,
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          user.image,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.32,
                        left: MediaQuery.of(context).size.width * 0.025,
                        right: MediaQuery.of(context).size.width * 0.025,
                      ),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.11,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24.w, vertical: 12.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50.w),
                                ),
                                color: AppColors.lightBlue.withOpacity(0.5),
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.65,
                                          child: Text(
                                            user.name,
                                            style: AppStyles.heading3.copyWith(
                                              color: AppColors.white,
                                            ),
                                            maxLines: 2,
                                          ),
                                        ),
                                        Text(
                                          user.email,
                                          style:
                                              AppStyles.supportiveText.copyWith(
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Posts',
                                          style: AppStyles.heading4.copyWith(
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.47,
                        left: MediaQuery.of(context).size.width * 0.025,
                        right: MediaQuery.of(context).size.width * 0.025,
                      ),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "My Posts",
                            style: AppStyles.heading4,
                          ),
                          SizedBox(
                            height: 12.w,
                          ),
                          SingleChildScrollView(
                            child: StaggeredGrid.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8.w,
                              mainAxisSpacing: 8.w,
                              children: List.generate(listings.length, (index) {
                                return PostCard(
                                  listing: listings[index],
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.w),
              ],
            ),
          ),
          Positioned(
            top: 16.w,
            right: 12.w,
            child: Container(
              height: 40.w,
              width: 40.w,
              margin: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20.w),
                ),
                color: AppColors.lightBlue.withOpacity(0.5),
              ),
              child: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 66.w,
            right: 12.w,
            child: const MembershipButton(
              textColor: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
