import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/modules/modules.dart';
import '../../usecases/event/load_current_event_factory.dart';
import '../../usecases/usecases.dart';

NewsPresenter makeNewsPresenter() => StreamNewsPresenter(
      loadNews: makeRemoteLoadNews(),
      loadCurrentEvent: makeLocalLoadCurrentEvent(),
      loadVoting: makeRemoteLoadVoting(),
    );
