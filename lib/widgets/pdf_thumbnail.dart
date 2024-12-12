// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

import '../localization/localization.dart';
import '../localization/translation_strings.dart';

class PdfThumbnail extends StatefulWidget {
  final String pdfUrl;

  const PdfThumbnail({super.key, required this.pdfUrl});

  @override
  _PdfThumbnailState createState() => _PdfThumbnailState();
}

class _PdfThumbnailState extends State<PdfThumbnail> {
  late Future<FileInfo> _pdfFile;
  bool _isPdfReady = false;

  @override
  void initState() {
    super.initState();
    _pdfFile = _downloadPdfFile(widget.pdfUrl);
    _pdfFile.then((fileInfo) {
      setState(() {
        _isPdfReady = true;
      });
    }).catchError((error) {
      debugPrint("Error downloading PDF: $error");
    });
  }

  Future<FileInfo> _downloadPdfFile(String url) {
    return DefaultCacheManager().downloadFile(url);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FileInfo>(
      future: _pdfFile,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !_isPdfReady) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text(
              '${AppLocalization.of(context)!.translate(TranslationString.failedToLoadPdf)} ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Text(AppLocalization.of(context)!
              .translate(TranslationString.noPdfAvailable));
        } else {
          return Container(
            height: 180,
            width: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.withOpacity(0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(0, 2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: const PDF(
                swipeHorizontal: true,
                pageSnap: true,
                fitEachPage: true,
                fitPolicy: FitPolicy.BOTH,
                autoSpacing: false,
              ).cachedFromUrl(
                widget.pdfUrl,
                placeholder: (progress) => Center(child: Text('$progress%')),
                errorWidget: (error) => Center(child: Text('Error: $error')),
              ),
            ),
          );
        }
      },
    );
  }
}
