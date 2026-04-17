import '../../../../presentation/presenters/broadcast/stream_broadcast_presenter.dart';
import '../../../../ui/modules/broadcast/broadcast_presenter.dart';
import '../../usecases/agenda/load_agenda_factory.dart';
import '../../usecases/broadcast/load_broadcast_factory.dart';
import '../../usecases/event/load_current_event_factory.dart';
import '../../usecases/translation/load_current_translation_factory.dart';

BroadcastPresenter makeBroadcastPresenter() => StreamBroadcastPresenter(
      loadBroadcast: makeRemoteLoadBroadcast(),
      loadCurrentEvent: makeLocalLoadCurrentEvent(),
      loadCurrentTranslation: makeLoadCurrentTranslation(),
      loadAgenda: makeRemoteLoadAgenda(),
    );
