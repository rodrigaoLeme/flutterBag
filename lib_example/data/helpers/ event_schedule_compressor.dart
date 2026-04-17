// ignore: file_names
import 'dart:convert';

import 'package:archive/archive.dart';

class EventScheduleCompressor {
  static String compress(List<dynamic> data) {
    final jsonString = jsonEncode(data);
    final bytes = utf8.encode(jsonString);
    final compressed = const GZipEncoder().encode(bytes);
    return base64Encode(compressed);
  }

  static List<dynamic> decompress(String compressedData) {
    final bytes = base64Decode(compressedData);
    final decompressed = const GZipDecoder().decodeBytes(bytes);
    final jsonString = utf8.decode(decompressed);
    return jsonDecode(jsonString) as List<dynamic>;
  }
}
