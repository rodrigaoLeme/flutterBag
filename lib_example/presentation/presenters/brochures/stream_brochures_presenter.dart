import 'dart:async';

import '../../../data/models/brochures/remote_brochures_model.dart';
import '../../../domain/usecases/brochures/load_brochures.dart';
import '../../../domain/usecases/event/load_current_event.dart';
import '../../../ui/modules/brochures/brochures_presenter.dart';
import '../../../ui/modules/brochures/brochures_view_model.dart';
import '../../mixins/mixins.dart';

class StreamBrochuresPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements BrochuresPresenter {
  final LoadBrochures loadBrochures;
  final LoadCurrentEvent loadCurrentEvent;

  StreamBrochuresPresenter({
    required this.loadBrochures,
    required this.loadCurrentEvent,
  });

  final StreamController<BrochuresViewModel?> _brochuresViewModel =
      StreamController<BrochuresViewModel?>.broadcast();
  @override
  Stream<BrochuresViewModel?> get brochuresViewModel =>
      _brochuresViewModel.stream;

  @override
  Future<void> loadData() async {
    try {
      isLoading = LoadingData(isLoading: true);
      final currentEvent = await loadCurrentEvent.load();
      loadBrochures
          .load(
        params: LoadBrochuresParams(
          eventId: currentEvent?.externalId ?? '',
        ),
      )
          ?.listen(
        (document) async {
          try {
            final model = RemoteBrochuresModel.fromDocument(document);
            final brochuresViewModel = BrochuresViewModelFactory.make(model);
            _brochuresViewModel.add(brochuresViewModel);
          } catch (e) {
            _brochuresViewModel.addError(e);
          } finally {
            isLoading = LoadingData(isLoading: false);
          }
        },
        onError: (error) {
          _brochuresViewModel.addError(error);
        },
      );
    } catch (error) {
      _brochuresViewModel.addError(error);
    }
  }

  @override
  void dispose() {
    _brochuresViewModel.close();
  }
}
