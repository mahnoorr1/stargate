// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../config/core.dart';
import '../../../drawer/widgets/widgets.dart';
import '../../../services/helper_methods.dart';
import '../../../utils/app_images.dart';

class LegalDocumentMainWidget extends StatefulWidget {
  final String label;
  final String text;
  String fileUrl;
  final String filter;

  LegalDocumentMainWidget({
    super.key,
    required this.label,
    required this.text,
    required this.fileUrl,
    required this.filter,
  });

  @override
  State<LegalDocumentMainWidget> createState() =>
      _LegalDocumentMainWidgetState();
}

class _LegalDocumentMainWidgetState extends State<LegalDocumentMainWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Heading(heading: widget.label),
                  SizedBox(height: 30.h),
                  Stack(
                    children: [
                      Container(
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
                                onTap: () {},
                                child: SvgPicture.asset(AppIcons.pdfIcon),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                getFileName(widget.fileUrl),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: AppStyles.normalText,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: InkWell(
                          onTap: () {},
                          child: const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              widget.text,
              style: AppStyles.normalText,
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
        ),
      ],
    );
  }
}
