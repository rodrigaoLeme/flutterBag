import 'package:flutter_modular/flutter_modular.dart';

import '../../ui/modules/auth/auth_presenter.dart';
import '../../ui/modules/auth/created_account_page.dart';
import '../../ui/modules/auth/terms_page.dart';
import '../../ui/modules/home/home_page.dart';
import '../factories/pages/auth/auth_page_factory.dart';
import '../factories/pages/notices_terms/notices_terms_page_factory.dart';
import '../factories/pages/onboarding/onboarding_page_factory.dart';
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
      AuthRoutes.terms,
      child: (_) => TermsPage(
        presenter: Modular.args.data as CreateAccountPresenter,
      ),
      transition: TransitionType.rightToLeft,
    );
    r.child(
      AuthRoutes.createdAccount,
      child: (_) => CreatedAccountPage(),
      transition: TransitionType.rightToLeft,
    );
    r.child(
      AuthRoutes.forgotPassword,
      child: (_) => makeForgotPasswordPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.onboarding,
      child: (_) => makeOnboardingPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.noticesTerms,
      child: (_) => makeNoticesTermsPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      AuthRoutes.home,
      child: (_) => const HomePage(),
      transition: TransitionType.fadeIn,
    );
  }
}
