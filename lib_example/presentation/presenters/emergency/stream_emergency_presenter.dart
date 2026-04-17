import 'dart:async';

import '../../../data/models/emergency/remote_emergency_model.dart';
import '../../../domain/usecases/emergency/load_emergency.dart';
import '../../../domain/usecases/event/load_current_event.dart';
import '../../../ui/modules/emergency/emergency_presenter.dart';
import '../../../ui/modules/emergency/emergency_view_model.dart';
import '../../mixins/mixins.dart';

class StreamEmergencyPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements EmergencyPresenter {
  LoadEmergency loadEmergency;
  LoadCurrentEvent loadCurrentEvent;

  StreamEmergencyPresenter({
    required this.loadEmergency,
    required this.loadCurrentEvent,
  });
  final StreamController<EmergencyViewModel?> _viewModel =
      StreamController<EmergencyViewModel?>.broadcast();
  @override
  Stream<EmergencyViewModel?> get viewModel => _viewModel.stream;

  @override
  Future<void> loadData() async {
    try {
      isLoading = LoadingData(isLoading: true);
      final currentEvent = await loadCurrentEvent.load();
      loadEmergency
          .load(
        params: LoadEmergencyParams(
          eventId: currentEvent?.externalId ?? '',
        ),
      )
          ?.listen(
        (document) async {
          try {
            final model = RemoteEmergencyModel.fromDocument(document);
            final emergencyViewModel =
                await EmergencyViewModelFactory.make(model);
            _viewModel.add(emergencyViewModel);
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
