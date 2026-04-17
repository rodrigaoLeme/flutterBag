import 'package:flutter/material.dart';

import '../../../../ui/modules/spiritual/prayer_room/prayer_room_page.dart';
import 'prayer_room_presenter_factory.dart';

Widget makePrayerRoomPage() => PrayerRoomPage(
      presenter: makePrayerRoomPresenter(),
    );
