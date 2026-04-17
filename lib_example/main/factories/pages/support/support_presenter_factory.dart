import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/modules/support/support_presenter.dart';
import '../../usecases/event/load_current_event_factory.dart';
import '../../usecases/usecases.dart';

SupportPresenter makeSupportPresenter() => StreamSupportPresenter(
      loadSupport: makeRemoteLoadSupport(),
      loadCurrentEvent: makeLocalLoadCurrentEvent(),
    );
