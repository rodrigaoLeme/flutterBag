import '../../../../presentation/presenters/navigation_bar/stream_navigation_bar_presenter.dart';
import '../../../../presentation/presenters/navigation_bar/tab_bar_itens.dart';
import '../../../../ui/modules/navigation/navigation_bar_presenter.dart';
import '../../usecases/event/load_current_event_factory.dart';
import '../../usecases/event_details/event_details.dart';

NavigationBarPresenter makeNavigationBarPresenter() =>
    StreamNavigationBarPresenter(
      loadCurrentEvent: makeLocalLoadCurrentEvent(),
      loadEventDetails: makeRemoteLoadEventDetails(),
    );

ParamController makeParamController() => ParamController();
