import 'package:flutter/material.dart';

import '../../../../ui/modules/home/processes_page.dart';
import 'home_presenter_factory.dart';

Widget makeProcessesPage() => ProcessesPage(
      presenter: makeHomePresenter(),
    );
