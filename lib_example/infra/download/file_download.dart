import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class PDFDownloader {
  static Future<String> downloadAndOpenPDF(String url, String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/$fileName';

      if (!File(filePath).existsSync()) {
        final dio = Dio();
        await dio.download(url, filePath);
      }
      return filePath;
    } catch (e) {
      print('Error while downloading the PDF: $e');
      return '';
    }
  }
}
