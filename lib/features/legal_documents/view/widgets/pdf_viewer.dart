// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:stargate/localization/localization.dart';
import 'package:stargate/localization/translation_strings.dart';

import '../../../../widgets/loader/loader.dart';

class PDFViewerScreen extends StatefulWidget {
  final String filePath;

  const PDFViewerScreen({super.key, required this.filePath});

  @override
  // ignore: library_private_types_in_public_api
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  String? localFilePath;

  @override
  void initState() {
    super.initState();
    _prepareFile();
  }

  Future<void> _prepareFile() async {
    if (widget.filePath.startsWith('http')) {
      // Download the file from the network
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/temp.pdf');
      final response = await http.get(Uri.parse(widget.filePath));
      await tempFile.writeAsBytes(response.bodyBytes);
      setState(() {
        localFilePath = tempFile.path;
      });
    } else {
      // Use the local file path directly
      setState(() {
        localFilePath = widget.filePath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context)!
            .translate(TranslationString.pdfViewer)),
      ),
      body: localFilePath != null
          ? PDFView(
              filePath: localFilePath!,
            )
          : const Center(child: Loader()),
    );
  }
}
