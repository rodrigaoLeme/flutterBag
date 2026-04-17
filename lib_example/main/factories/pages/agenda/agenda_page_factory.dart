import 'package:flutter/material.dart';

import '../../../../ui/modules/modules.dart';
import 'agenda_presenter_factory.dart';

Widget makeAgendaPage() => AgendaPage(
      presenter: makeAgendaPresenter(),
    );
