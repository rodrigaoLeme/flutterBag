import 'package:flutter/material.dart';

import '../../../../ui/modules/modules.dart';
import 'support_presenter_factory.dart';

Widget makeSupportPage() => SupportPage(
      presenter: makeSupportPresenter(),
    );
