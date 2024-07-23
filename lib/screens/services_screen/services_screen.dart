import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stargate/config/core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/utils/app_enums.dart';
import 'package:stargate/widgets/buttons/filter_button.dart';
import 'package:stargate/widgets/cards/listing_card.dart';

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
                  (type) => customTabButton(type),
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
                      onTap: () {},
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

  Widget customTabButton(UserType type) {
    List<String> titles = [
      'investors',
      'agents',
      'lawyers',
      'notaries',
      'appraisers',
    ];
    int index() {
      if (type == UserType.investor) {
        return 0;
      } else if (type == UserType.agent) {
        return 1;
      } else if (type == UserType.lawyer) {
        return 2;
      } else if (type == UserType.notary) {
        return 3;
      } else if (type == UserType.appraiser) {
        return 4;
      }
      return 0;
    }

    bool isSelected = selectedUser == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedUser = type;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 10.w, bottom: 12.w),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          color: isSelected == true ? AppColors.blue : AppColors.lightBlue,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.w),
          child: Center(
            child: Text(
              titles[index()],
              style: isSelected == true
                  ? AppStyles.heading4.copyWith(color: AppColors.white)
                  : AppStyles.normalText,
            ),
          ),
        ),
      ),
    );
  }
}
