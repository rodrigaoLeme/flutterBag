import '../../../../presentation/presenters/event_details/event_details.dart';
import '../../../../ui/modules/event_details/event_details_presenter.dart';
import '../../usecases/agenda/load_current_agenda_factory.dart';
import '../../usecases/agenda/save_current_agenda_factory.dart';
import '../../usecases/event/load_current_event_factory.dart';
import '../../usecases/usecases.dart';

EventDetailsPresenter makeEventDetailsPresenter() =>
    StreamEventDetailsPresenter(
      loadEventDetails: makeRemoteLoadEventDetails(),
      loadCurrentEvent: makeLocalLoadCurrentEvent(),
      saveCurrentAgenda: makeSaveCurrentAgenda(),
      loadCurrentAgenda: makeLocalLoadCurrentAgenda(),
    );
