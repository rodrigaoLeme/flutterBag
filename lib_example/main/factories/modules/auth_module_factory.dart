import 'package:flutter_modular/flutter_modular.dart';

import '../../routes/core_module.dart';
import '../../routes/routes_app.dart';
import '../pages/choose_event/choose_event_page_factory.dart';
import '../pages/dashboard/nav_bar_page_factory.dart';
import '../pages/pages.dart';

class AuthModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child(
      Routes.splash,
      child: (_) => makeSplashPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.dashboard,
      child: (_) => makeDashboardPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.chooseEvent,
      child: (_) => makeChooseEventPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.navBar,
      child: (_) => makeNavBarPage(),
      transition: TransitionType.fadeIn,
    );
  }
}
