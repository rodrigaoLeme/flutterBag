import 'package:flutter/material.dart';

import '../../../../ui/modules/menu/menu_page.dart';
import 'menu_presenter_factory.dart';

Widget makeMenuPage() {
  return MenuPage(
    presenter: makeMenuPresenter(),
  );
}
