import 'package:flutter/material.dart';

import '../../../../ui/modules/spiritual/spiritual_page.dart';
import 'spiritual_presenter_factory.dart';

Widget makeSpiritualPage() => SpiritualPage(
      presenter: makeSpiritualPresenter(),
    );
