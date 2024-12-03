import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/content_management/providers/membership_content.dart';
import 'package:stargate/utils/app_data.dart';
import 'package:stargate/widgets/buttons/back_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/widgets/cards/membership_card.dart';
import 'package:stargate/widgets/loader/loader.dart';
import 'package:stargate/widgets/screen/screen.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  bool loaded = false;
  @override
  void initState() {
    super.initState();
    MembershipContentProvider().fetchMembershipContent();
    Future.delayed(Duration(seconds: 2));
    setState(() {
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("inside");
    final membershipContentProvider =
        Provider.of<MembershipContentProvider>(context, listen: false);
    return Screen(
      overlayWidgets: [
        if (membershipContentProvider.isLoading || !loaded)
          const FullScreenLoader(
            loading: true,
          )
      ],
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          leading: const CustomBackButton(
            color: AppColors.darkBlue,
          ),
        ),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 18.w,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                "Membership",
                style: AppStyles.heading2.copyWith(
                  color: AppColors.darkBlue,
                ),
              ),
            ),
            SizedBox(
              height: 6.w,
            ),
            ...membershipContentProvider.membershipContent!.map(
              (item) => MembershipCard(
                membership: item,
                activeMembership:
                    membershipContentProvider.membershipContent![0].tag ?? '',
              ),
            ),
            SizedBox(
              height: 18.w,
            ),
          ]),
        ),
      ),
    );
  }
}
