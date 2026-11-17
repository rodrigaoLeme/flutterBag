import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

Future<bool> isLikelyEncryptedPdf(String path) {
  return Isolate.run(() {
    final bytes = File(path).readAsBytesSync();
    return latin1.decode(bytes).contains('/Encrypt');
  });
}
