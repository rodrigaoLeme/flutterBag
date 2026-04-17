import 'package:firebase_messaging/firebase_messaging.dart';

abstract class LoadCurrentScreenType {
  Future<RemoteMessage?> load();
}
