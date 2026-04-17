import '../../../../presentation/presenters/spiritual/stream_spiritual_presenter.dart';
import '../../../../ui/modules/spiritual/spiritual_presenter.dart';
import '../../usecases/event/load_current_event_factory.dart';
import '../../usecases/spiritual/load_spiritual_factory.dart';

SpiritualPresenter makeSpiritualPresenter() => StreamSpiritualPresenter(
      loadSpiritual: makeRemoteLoadSpiritual(),
      loadCurrentEvent: makeLocalLoadCurrentEvent(),
    );
