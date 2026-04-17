import '../../../../presentation/presenters/transport/stream_transport_presenter.dart';
import '../../../../ui/modules/transport/transport_presenter.dart';
import '../../usecases/event/load_current_event_factory.dart';
import '../../usecases/transport/load_transport_factory.dart';

TransportPresenter makeTransportPresenter() => StreamTransportPresenter(
      loadTransport: makeRemoteLoadTransport(),
      loadCurrentEvent: makeLocalLoadCurrentEvent(),
    );
