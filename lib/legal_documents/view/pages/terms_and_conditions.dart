import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/core.dart';
import '../widgets/legal_document_main_widget.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        color: AppColors.backgroundColor,
        child: LegalDocumentMainWidget(
          label: "Terms and Conditions",
          text: "This is the Terms and Conditions",
          fileUrl: "termsAndConditions.com",
          filter: 'termsAndConditions',
        ),
      ),
    );
  }
}
