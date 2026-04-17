import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../presentation/presenters/navigation_bar/tab_bar_itens.dart';
import '../../../../ui/modules/maps/map_by_server.dart';
import 'map_presenter_factory.dart';

Widget makeMapPage() {
  final paramController = Modular.get<ParamController>();
  final path = paramController.getParam();
  paramController.setParam('');
  return LocalWebViewPageByServer(
    hashPath: path,
    presenter: makeMapPresenter(),
  );
}
