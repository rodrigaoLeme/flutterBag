import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../ui/modules/navigation/navigation_bar_page.dart';
import '../../../../ui/modules/navigation/navigation_bar_presenter.dart';

Widget makeNavBarPage() {
  final presenter = Modular.get<NavigationBarPresenter>();
  return NavigationBarPage(
    presenter: presenter,
  );
}
