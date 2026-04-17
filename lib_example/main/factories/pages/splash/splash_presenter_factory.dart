import '../../../../presentation/presenters/splash/stream_splash_presenter.dart';
import '../../../../ui/modules/splash/splash_presenter.dart';
import '../../usecases/event/choose_event_once_factory.dart';
import '../../usecases/event/load_current_event_factory.dart';
import '../../usecases/translation/load_current_translation_factory.dart';

SplashPresenter makeSplashPresenter() => StreamSplashPresenter(
      loadCurrentEvent: makeLocalLoadCurrentEvent(),
      loadCurrentTranslation: makeLoadCurrentTranslation(),
      loadActiveEvent: makeRemoteLoadActiveEventOnce(),
    );
