import 'package:flutter/material.dart';

import '../../../../ui/modules/modules.dart';
import 'st_louis_presenter_factory.dart';

Widget makeStLouisPage() => StLouisPage(
      presenter: makeStLouisPresenter(),
    );
