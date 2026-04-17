import '../../../../presentation/presenters/splash/stream_splash_presenter.dart';
import '../../../../ui/modules/splash/splash_presenter.dart';
import '../../usecases/account/load_current_account_factory.dart';

SplashPresenter makeSplashPresenter() => StreamSplashPresenter(
      loadCurrentAccount: makeLocalLoadCurrentAccount(),
    );
