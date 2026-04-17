import 'package:flutter/material.dart';

import '../../../../ui/modules/spiritual/devotional/devotional_page.dart';
import 'devotional_presenter_favtory.dart';

Widget makeDevotionalPage() => DevotionalPage(
      presenter: makeDevotionalPresenter(),
    );
