import 'dart:async';

import '../../../data/models/transport/remote_transport_model.dart';
import '../../../domain/usecases/event/load_current_event.dart';
import '../../../domain/usecases/transport/load_transport.dart';
import '../../../ui/modules/transport/transport_presenter.dart';
import '../../../ui/modules/transport/transport_view_model.dart';
import '../../mixins/mixins.dart';

class StreamTransportPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements TransportPresenter {
  final LoadTransport loadTransport;
  LoadCurrentEvent loadCurrentEvent;

  StreamTransportPresenter({
    required this.loadTransport,
    required this.loadCurrentEvent,
  });

  final StreamController<TransportViewModel?> _viewModel =
      StreamController<TransportViewModel?>.broadcast();
  @override
  Stream<TransportViewModel?> get viewModel => _viewModel.stream;

  @override
  Future<void> loadData() async {
    try {
      isLoading = LoadingData(isLoading: true);

      final currentEvent = await loadCurrentEvent.load();
      loadTransport
          .load(
        params: LoadTransportParams(
          eventId: currentEvent?.externalId ?? '',
        ),
      )
          ?.listen(
        (document) async {
          try {
            final model = RemoteTransportModel.fromDocument(document);
            final transportation = await TransportViewModelFactory.make(model);
            _viewModel.add(transportation);
          } catch (e) {
            _viewModel.addError(e);
          } finally {
            isLoading = LoadingData(isLoading: false);
          }
        },
        onError: (error) {
          _viewModel.addError(error);
        },
      );
    } catch (error) {
      _viewModel.addError(error);
    }
  }

  @override
  void dispose() {
    _viewModel.close();
  }
}
