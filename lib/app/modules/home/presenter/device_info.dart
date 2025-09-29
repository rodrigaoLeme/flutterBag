import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class DeviceInfo {
  static DeviceInfo shared = DeviceInfo._();
  DeviceInfo._();

  String deviceCode = "";

  Future init({bool reset = false}) async {
    const storage = FlutterSecureStorage();
    if (!reset) {
      try {
        deviceCode = (await storage.read(key: "EBOLSA-DEVICE-CODE") ?? "");
      } on PlatformException {
        storage.deleteAll();
        deviceCode = "";
      }
    }
    if (deviceCode == "" || reset) {
      deviceCode = const Uuid().v4();
      await storage.write(key: "EBOLSA-DEVICE-CODE", value: deviceCode);
    }
  }

  Future changeCode(String code) async {
    deviceCode = code;
    const storage = FlutterSecureStorage();
    await storage.write(key: "EBOLSA-DEVICE-CODE", value: deviceCode);
  }

  Future setNewData(String deviceCode, String emailAddres) async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();
    //deviceCode = (deviceCode == "") ? const Uuid().v4() : deviceCode;
    storage.write(key: "EBOLSA-DEVICE-CODE", value: deviceCode);
    storage.write(key: "EBOLSA-EMAILADDRES", value: emailAddres);
  }
}
