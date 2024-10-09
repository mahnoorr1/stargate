import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/core.dart';
import '../widgets/legal_document_main_widget.dart';

class LegalNoticeScreen extends StatelessWidget {
  const LegalNoticeScreen({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        color: AppColors.backgroundColor,
        child: LegalDocumentMainWidget(
          label: "Legal Notice",
          text: "This is the legal notice",
          fileUrl: "legal.com",
          filter: 'legal',
        ),
      ),
    );
  }
}
