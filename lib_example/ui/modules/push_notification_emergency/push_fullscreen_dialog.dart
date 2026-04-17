import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../../main/factories/pages/push_notification_emergency/push_notification_emergency_presenter_factory.dart';
import '../../helpers/i18n/resources.dart';
import 'push_notification_emergency_page.dart';

Future<void> showPushFullScreen(
    BuildContext context, RemoteMessage message) async {
  Future.delayed(
    Duration.zero,
    () async {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: R.string.emergencyLabel,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) {
          return PushNotificationEmergencyPage(
            message: message,
            presenter: makePushNotificationEmergencyPresenter(),
          );
        },
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      );
    },
  );
}
