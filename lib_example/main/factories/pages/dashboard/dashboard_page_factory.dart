import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../ui/modules/dashboard/dashboard.dart';
import '../../../../ui/modules/navigation/navigation_bar_presenter.dart';
import 'dashboard_presenter_factory.dart';

Widget makeDashboardPage() {
  final presenter = Modular.get<NavigationBarPresenter>();
  return DashboardPage(
    presenter: makeDashboardPresenter(),
    tabBarPresenter: presenter,
  );
}
