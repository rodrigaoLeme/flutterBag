import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../modules/push_notification_emergency/push_fullscreen_dialog.dart';

class PushFullscreenManagerListener {
  static void handleFullScreen(
      BuildContext context, Stream<RemoteMessage> stream) {
    stream.listen(
      (value) async {
        await showPushFullScreen(context, value);
      },
    );
  }
}
