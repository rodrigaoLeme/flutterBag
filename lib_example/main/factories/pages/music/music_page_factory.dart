import 'package:flutter/material.dart';

import '../../../../ui/modules/spiritual/music/music_page.dart';
import 'music_presenter_factory.dart';

Widget makeMusicPage() => MusicPage(
      presenter: makeMusicPresenter(),
    );
