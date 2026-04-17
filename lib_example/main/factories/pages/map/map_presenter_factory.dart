import '../../../../presentation/presenters/maps/stream_maps_presenter.dart';
import '../../../../ui/modules/maps/maps_presenter.dart';
import '../../usecases/event/load_current_event_factory.dart';
import '../../usecases/map/load_map_factory.dart';
import '../../usecases/usecases.dart';

MapPresenter makeMapPresenter() => StreamMapPresenter(
      loadCurrentEvent: makeLocalLoadCurrentEvent(),
      loadMap: makeRemoteLoadMap(),
      loadEventDetails: makeRemoteLoadEventDetails(),
    );
