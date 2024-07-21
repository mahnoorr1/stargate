import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stargate/config/core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/widgets/buttons/filter_button.dart';
import 'package:stargate/widgets/cards/listing_card.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  List<String> items = [
    'Mahnoor Hashmi',
    'lara Willson',
    'johnson',
    'Braid Pitt',
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
        child: SingleChildScrollView(
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
      ),
    );
  }
}
