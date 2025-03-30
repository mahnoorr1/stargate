// screens/membership_screen.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/localization/localization.dart';
import 'package:stargate/localization/translation_strings.dart';
import 'package:stargate/widgets/buttons/back_button.dart';
import 'package:stargate/widgets/loader/loader.dart';
import 'package:stargate/widgets/screen/screen.dart';

import '../../../widgets/custom_toast.dart';
import '../providers/membership_provider.dart';
import 'membership_card.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch memberships when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MembershipProvider>(context, listen: false).getMemberships();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      overlayWidgets: [
        Consumer<MembershipProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading || provider.isApplying) {
              return const FullScreenLoader(loading: true);
            }
            return const SizedBox.shrink();
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          surfaceTintColor: Colors.transparent,
          leading: const CustomBackButton(
            color: AppColors.darkBlue,
          ),
        ),
        body: Consumer<MembershipProvider>(
          builder: (context, provider, child) {
            if (provider.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Something went wrong',
                      style: AppStyles.heading3.copyWith(
                        color: AppColors.darkBlue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.errorMessage!,
                      style: AppStyles.heading3,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.getMemberships(),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }

            if (provider.memberships.isEmpty && !provider.isLoading) {
              return Center(
                child: Text(
                  'No memberships available',
                  style: AppStyles.heading3.copyWith(
                    color: AppColors.darkBlue,
                  ),
                ),
              );
            }

            return SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 18.w),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        AppLocalization.of(context)!.translate(
                          TranslationString.membership,
                        ),
                        style: AppStyles.heading2.copyWith(
                          color: AppColors.darkBlue,
                        ),
                      ),
                    ),
                    SizedBox(height: 6.w),
                    ...provider.memberships.map(
                      (membership) => MembershipCard(
                        membership: membership,
                        onApply: provider.canApply
                            ? () => _applyForMembership(context, membership.id)
                            : () {
                                showToast(
                                    message:
                                        "You've already applied for a membership. Please wait for approval before applying again.",
                                    context: context,
                                    isAlert: true);
                              },
                      ),
                    ),
                    SizedBox(height: 18.w),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _applyForMembership(
      BuildContext context, String membershipId) async {
    final provider = Provider.of<MembershipProvider>(context, listen: false);

    final result = await provider.applyForMembership(membershipId);

    if (result) {
      showToast(
        message: 'Membership application submitted successfully',
        context: context,
        isAlert: false,
      );
    } else {
      showToast(
        message: provider.errorMessage ?? 'Failed to apply for membership',
        context: context,
        isAlert: true,
      );
    }
  }
}
