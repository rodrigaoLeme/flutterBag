import '../../../../presentation/presenters/brochures/stream_brochures_presenter.dart';
import '../../../../ui/modules/brochures/brochures_presenter.dart';
import '../../usecases/brochures/load_brochures_factory.dart';
import '../../usecases/event/load_current_event_factory.dart';

BrochuresPresenter makeBrochuresPresenter() => StreamBrochuresPresenter(
      loadBrochures: makeRemoteLoadBrochures(),
      loadCurrentEvent: makeLocalLoadCurrentEvent(),
    );
