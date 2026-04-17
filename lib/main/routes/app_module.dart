import 'package:flutter_modular/flutter_modular.dart';

import '../factories/pages/auth/add_account_page_factory.dart';
import '../factories/pages/auth/login_page_factory.dart';
import '../factories/pages/splash/splash_page_factory.dart';
import 'routes.dart';

class AppModule extends Module {
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
      Routes.login,
      child: (_) => makeLoginPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.addAccount,
      child: (_) => makeAddAccountPage(),
      transition: TransitionType.fadeIn,
    );
  }
}
