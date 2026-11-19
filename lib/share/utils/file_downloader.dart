import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

Future<File> downloadToTemp(String url, {required String filename}) async {
  final dir = await getTemporaryDirectory();
  final safeName = filename.replaceAll(RegExp(r'[^\w.\- ]'), '_');
  final file = File('${dir.path}/$safeName');
  await Dio().download(url, file.path);
  return file;
}
