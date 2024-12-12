import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:stargate/services/helper_methods.dart';

import '../localization/localization.dart';
import '../localization/translation_strings.dart';
import 'loader/loader.dart';

class PDFViewerScreen extends StatefulWidget {
  final String filePath;

  const PDFViewerScreen({super.key, required this.filePath});

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  String? localFilePath;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _prepareFile();
  }

  Future<void> _prepareFile() async {
    try {
      if (widget.filePath.startsWith('http')) {
        // Download the file from the network
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/temp.pdf');

        final response = await http.get(Uri.parse(widget.filePath));
        if (response.statusCode == 200) {
          await tempFile.writeAsBytes(response.bodyBytes);
          setState(() {
            localFilePath = tempFile.path;
            isLoading = false;
          });
        } else {
          throw Exception(
              'Failed to load PDF from URL: ${response.statusCode}');
        }
      } else if (File(widget.filePath).existsSync()) {
        // Use the local file path directly if it exists
        setState(() {
          localFilePath = widget.filePath;
          isLoading = false;
        });
      } else {
        throw Exception('Local PDF file not found at path: ${widget.filePath}');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getFileName(widget.filePath)),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: Loader())
          : errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          errorMessage!,
                          textAlign: TextAlign.center,
                          style:
                              const TextStyle(fontSize: 16, color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(AppLocalization.of(context)!
                              .translate(TranslationString.goBack)),
                        ),
                      ],
                    ),
                  ),
                )
              : PDFView(
                  key: ValueKey(localFilePath), // Forces widget to rebuild
                  filePath: localFilePath!,
                ),
    );
  }
}
