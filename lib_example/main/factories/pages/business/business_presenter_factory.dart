import '../../../../presentation/presenters/business/stream_business_presenter.dart';
import '../../../../ui/modules/business/business_presenter.dart';
import '../../usecases/business/load_business_factory.dart';
import '../../usecases/event/load_current_event_factory.dart';
import '../../usecases/voting/load_voting_factory.dart';

BusinessPresenter makeBusinessPresenter() => StreamBusinessPresenter(
      loadBusiness: makeRemoteLoadBusiness(),
      loadVoting: makeRemoteLoadVoting(),
      loadCurrentEvent: makeLocalLoadCurrentEvent(),
    );
