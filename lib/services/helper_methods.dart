import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

Future<File> assetImageToFile(String assetPath) async {
  ByteData byteData = await rootBundle.load(assetPath);
  final tempDir = await getTemporaryDirectory();
  File file = File('${tempDir.path}/temp_image.jpeg');
  await file.writeAsBytes(byteData.buffer.asUint8List());
  return file;
}

String getFileName(String filePath) {
  String fileName = filePath.split('/').last;
  return fileName.replaceFirst(RegExp(r'^\d+-'), '');
}

class AppFailure {
  final String message;

  AppFailure(
      [this.message = 'Sorry, something went wrong. Please try again later.']);

  @override
  String toString() => 'AppFailure(message: $message)';
}
