// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:stargate/localization/translation_strings.dart';

import '../localization/localization.dart';

class MyPdfViewer extends StatefulWidget {
  String pdfPath;
  MyPdfViewer({super.key, required this.pdfPath});
  @override
  _MyPdfViewerState createState() => _MyPdfViewerState();
}

class _MyPdfViewerState extends State<MyPdfViewer> {
  late PDFViewController pdfViewController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${AppLocalization.of(context)!.translate(TranslationString.referenceFile)} ${widget.pdfPath}"),
      ),
      body: PDFView(
        filePath: widget.pdfPath,
        autoSpacing: true,
        enableSwipe: true,
        pageSnap: true,
        swipeHorizontal: true,
        onViewCreated: (PDFViewController vc) {
          pdfViewController = vc;
        },
      ),
    );
  }
}
