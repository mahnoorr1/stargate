// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stargate/legal_documents/view/widgets/pdf_viewer.dart';

import '../../../config/core.dart';

import '../../../services/helper_methods.dart';
import '../../../utils/app_images.dart';

class LegalDocumentDataWidget extends StatelessWidget {
  final String text;
  String fileUrl;

  LegalDocumentDataWidget({
    super.key,
    required this.text,
    required this.fileUrl,
  });

  @override
  Widget build(BuildContext context) {
    void openPDFViewer(BuildContext context, String filePath) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerScreen(filePath: filePath),
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: fileUrl != "" ? 10.h : 20.h),
                fileUrl != ""
                    ? Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          border: Border.all(color: AppColors.lightGrey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  openPDFViewer(context, fileUrl);
                                },
                                child: SvgPicture.asset(AppIcons.pdfIcon),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                getFileName(fileUrl),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: AppStyles.normalText,
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  text,
                  style: AppStyles.normalText,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
