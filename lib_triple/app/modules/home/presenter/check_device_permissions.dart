import 'dart:io';

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
      if (await Permission.camera.isDenied) {
        final granted = await Permission.camera.request();
        if (!granted.isGranted) denied.add('Câmera');
      }

      if (denied.isNotEmpty) {
        throw Exception("Permissões negadas: ${denied.join(', ')}");
      }
    }

    return true;
  }
}
