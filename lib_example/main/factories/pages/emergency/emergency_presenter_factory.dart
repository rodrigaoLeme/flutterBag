import '../../../../presentation/presenters/emergency/stream_emergency_presenter.dart';
import '../../../../ui/modules/emergency/emergency_presenter.dart';
import '../../usecases/emergency/load_emergency_factory.dart';
import '../../usecases/event/load_current_event_factory.dart';

EmergencyPresenter makeEmergencyPresenter() => StreamEmergencyPresenter(
      loadEmergency: makeRemoteLoadEmergency(),
      loadCurrentEvent: makeLocalLoadCurrentEvent(),
    );
