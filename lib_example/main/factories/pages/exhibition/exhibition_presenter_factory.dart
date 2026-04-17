import '../../../../presentation/presenters/exhibition/stream_exhibition_presenter.dart';
import '../../../../ui/modules/exhibition/exhibition_presenter.dart';
import '../../usecases/event/load_current_event_factory.dart';
import '../../usecases/exhibition/load_current_exhibitor_factory.dart';
import '../../usecases/exhibition/save_current_exhibitor_factory.dart';
import '../../usecases/usecases.dart';

ExhibitionPresenter makeExhibitionPresenter() => StreamExhibitionPresenter(
      loadExhibition: makeRemoteLoadExhibition(),
      loadCurrentEvent: makeLocalLoadCurrentEvent(),
      localSaveCurrentExhibitor: makeSaveCurrentExhibitions(),
      loadCurrentExhibitor: makeLoadCurrentExhibitor(),
    );
