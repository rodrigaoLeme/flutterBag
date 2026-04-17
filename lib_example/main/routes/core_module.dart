import 'package:flutter_modular/flutter_modular.dart';

import '../../presentation/presenters/navigation_bar/tab_bar_itens.dart';
import '../../ui/modules/navigation/navigation_bar_presenter.dart';
import '../factories/pages/dashboard/nav_bar_presenter_factory.dart';

class CoreModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<NavigationBarPresenter>(makeNavigationBarPresenter);
    i.addSingleton<ParamController>(makeParamController);
  }

  @override
  void routes(r) {}
}
