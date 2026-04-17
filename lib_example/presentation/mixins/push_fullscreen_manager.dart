import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushFullscreenManager {
  static final PushFullscreenManager _instance =
      PushFullscreenManager._internal();

  factory PushFullscreenManager() {
    return _instance;
  }

  PushFullscreenManager._internal();

  final StreamController<RemoteMessage> _isShowingStreamController =
      StreamController<RemoteMessage>.broadcast();

  Stream<RemoteMessage> get isShowingStream =>
      _isShowingStreamController.stream;
  set isShowing(RemoteMessage value) =>
      _isShowingStreamController.sink.add(value);
}
