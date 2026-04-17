import 'package:flutter/material.dart';

import '../../../../ui/modules/notification/notification_page.dart';
import 'notification_presenter_factory.dart';

Widget makeNotificationPage() => NotificationPage(
      presenter: makeNotificationPresenter(),
    );
