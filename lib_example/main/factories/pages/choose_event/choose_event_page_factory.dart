import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../ui/modules/choose_event/choose_event_page.dart';
import '../../../../ui/modules/navigation/navigation_bar_presenter.dart';
import 'choose_event_presenter_factory.dart';

Widget makeChooseEventPage() {
  final presenter = Modular.get<NavigationBarPresenter>();
  return ChooseEventPage(
    presenter: makeChooseEventPresenter(),
    tabBarPresenter: presenter,
  );
}
