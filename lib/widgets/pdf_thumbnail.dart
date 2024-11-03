import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:stargate/config/core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PdfThumbnail extends StatefulWidget {
  const PdfThumbnail({super.key});

  @override
  _PdfThumbnail createState() => _PdfThumbnail();
}

class _PdfThumbnail extends State<PdfThumbnail> {
  late Future<FileInfo> _pdfFile;
  bool _isPdfReady = false;

  @override
  void initState() {
    super.initState();
    _pdfFile = _downloadPdfFile(
        'https://www.elearn.gov.pk/onlinepdf/physics/9physics/pdfEng/chapter3.pdf');
    _pdfFile.then((fileInfo) {
      setState(() {
        _isPdfReady = true;
      });
    }).catchError((error) {});
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
          return SizedBox(
            height: 50.w,
            width: 50.w,
            child: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Text('No PDF available');
        } else {
          return Container(
            height: 180,
            width: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20.w),
              ),
              boxShadow: [AppStyles.boxShadow],
              // ignore: deprecated_member_use
              color: AppColors.lightGrey.withOpacity(0.5),
            ),
            child: const PDF(
              swipeHorizontal: true,
              pageSnap: true,
              fitEachPage: true,
              fitPolicy: FitPolicy.BOTH,
              autoSpacing: false,
            ).cachedFromUrl(
              snapshot.data!.originalUrl,
            ),
          );
        }
      },
    );
  }
}
