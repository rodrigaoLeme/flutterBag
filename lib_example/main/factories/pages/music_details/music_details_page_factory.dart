import 'package:flutter/material.dart';

import '../../../../ui/modules/spiritual/music/details/music_details_page.dart';
import 'music_details_presenter_factory.dart';

Widget makeMusicDetailsPage() => MusicDetailsPage(
      presenter: makeMusicDetailsPresenter(),
    );
