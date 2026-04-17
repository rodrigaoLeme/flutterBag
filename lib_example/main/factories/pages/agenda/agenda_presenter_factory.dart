import '../../../../presentation/presenters/agenda/agenda.dart';
import '../../../../ui/modules/modules.dart';
import '../../usecases/agenda/load_agenda_factory.dart';
import '../../usecases/agenda/load_current_agenda_factory.dart';
import '../../usecases/agenda/save_current_agenda_factory.dart';
import '../../usecases/event/load_current_event_factory.dart';

AgendaPresenter makeAgendaPresenter() => StreamAgendaPresenter(
      loadAgenda: makeRemoteLoadAgenda(),
      loadCurrentEvent: makeLocalLoadCurrentEvent(),
      saveCurrentAgenda: makeSaveCurrentAgenda(),
      loadCurrentAgenda: makeLocalLoadCurrentAgenda(),
    );
