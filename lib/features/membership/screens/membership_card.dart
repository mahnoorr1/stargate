// widgets/membership_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/config/core.dart';

import '../models/membership_model.dart';

class MembershipCard extends StatelessWidget {
  final Membership membership;
  final Function()? onApply;

  const MembershipCard({
    super.key,
    required this.membership,
    this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    membership.name,
                    style: AppStyles.heading3.copyWith(
                      color: AppColors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (membership.isActive)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.w,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      'Active',
                      style: AppStyles.heading4.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (membership.isApplied != false)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.w,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      'Pending',
                      style: AppStyles.heading4.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...membership.privileges
                    .where((privilege) => privilege.isNotEmpty)
                    .map(
                      (privilege) => Padding(
                        padding: EdgeInsets.only(bottom: 8.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: AppColors.blue,
                              size: 20.w,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                privilege,
                                style: AppStyles.heading4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
          ),
          if (!membership.isActive && membership.isApplied == false)
            membership.identifier == "free_trial" ||
                    membership.identifier == "restricted_access"
                ? const SizedBox()
                : Padding(
                    padding: EdgeInsets.all(16.w),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onApply,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue,
                          padding: EdgeInsets.symmetric(vertical: 12.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'Apply',
                          style: AppStyles.heading4.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
          // if (membership.isActive)
          //   Padding(
          //     padding: EdgeInsets.all(16.w),
          //     child: SizedBox(
          //       width: double.infinity,
          //       child: ElevatedButton(
          //         onPressed: null,
          //         style: ElevatedButton.styleFrom(
          //           backgroundColor: Colors.grey[300],
          //           padding: EdgeInsets.symmetric(vertical: 12.w),
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(8.r),
          //           ),
          //         ),
          //         child: Text(
          //           'Subscribed',
          //           style: AppStyles.heading4.copyWith(
          //             color: Colors.grey[700],
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          if (membership.isApplied != false)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    padding: EdgeInsets.symmetric(vertical: 12.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Pending Approval',
                    style: AppStyles.heading4.copyWith(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
