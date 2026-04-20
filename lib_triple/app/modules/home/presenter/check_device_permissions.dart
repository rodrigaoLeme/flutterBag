import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class CheckDevicePermissions {
  static CheckDevicePermissions shared = CheckDevicePermissions._();
  CheckDevicePermissions._();

  Future<bool> checkScannerPermissions(BuildContext context) async {
    final denied = <String>[];

    if (Platform.isIOS) {
      final photos = await Permission.photos.request();
      if (!photos.isGranted) denied.add('Fotos (iOS)');
    }

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (await Permission.camera.isDenied) {
        final granted = await Permission.camera.request();
        if (!granted.isGranted) denied.add('Câmera');
      }

      if (sdkInt >= 33) {
        final photos = await Permission.photos.request();
        final videos = await Permission.videos.request();

        if (!photos.isGranted) denied.add('Fotos');
        if (!videos.isGranted) denied.add('Vídeos');
      } else {
        final storage = await Permission.storage.request();
        if (!storage.isGranted) denied.add('Armazenamento');
      }

      if (denied.isNotEmpty) {
        throw Exception("Permissões negadas: ${denied.join(', ')}");
      }
    }

    return true;
  }
}
