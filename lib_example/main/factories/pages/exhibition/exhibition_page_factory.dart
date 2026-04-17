import 'package:flutter/material.dart';

import '../../../../ui/modules/modules.dart';
import 'exhibition_presenter_factory.dart';

Widget makeExhibitionPage() => ExhibitionPage(
      presenter: makeExhibitionPresenter(),
    );
