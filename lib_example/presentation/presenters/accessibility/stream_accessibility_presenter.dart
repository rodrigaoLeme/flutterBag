import 'dart:async';

import '../../../data/models/accessibility/accessibility_model.dart';
import '../../../domain/usecases/accessibility/load_accessibility.dart';
import '../../../domain/usecases/event/load_current_event.dart';
import '../../../ui/modules/accessibility/accessibility_presenter.dart';
import '../../../ui/modules/accessibility/accessibility_view_model.dart';
import '../../mixins/mixins.dart';

class StreamAccessibilityPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements AccessibilityPresenter {
  final LoadAccessibility loadAccessibility;
  LoadCurrentEvent loadCurrentEvent;

  StreamAccessibilityPresenter({
    required this.loadAccessibility,
    required this.loadCurrentEvent,
  });

  final StreamController<AccessibilityViewModel?> _viewModel =
      StreamController<AccessibilityViewModel?>.broadcast();
  @override
  Stream<AccessibilityViewModel?> get viewModel => _viewModel.stream;

  @override
  Future<void> loadData() async {
    try {
      isLoading = LoadingData(isLoading: true);

      final currentEvent = await loadCurrentEvent.load();
      loadAccessibility
          .load(
        params: LoadAccessibilityParams(
          eventId: currentEvent?.externalId ?? '',
        ),
      )
          ?.listen(
        (document) async {
          try {
            final model = RemoteAccessibilityModel.fromDocument(document);
            final accessibility =
                await AccessibilityViewModelFactory.make(model);
            _viewModel.add(accessibility);
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
