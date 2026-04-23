import 'package:flutter_modular/flutter_modular.dart';

import '../factories/pages/auth/auth_page_factory.dart';
import '../factories/pages/splash/splash_page_factory.dart';
import 'auth_routes.dart';
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
      AuthRoutes.login,
      child: (_) => makeLoginPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      AuthRoutes.createAccount,
      child: (_) => makeCreateAccountPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      AuthRoutes.forgotPassword,
      child: (_) => makeForgotPasswordPage(),
      transition: TransitionType.fadeIn,
    );
  }
}
