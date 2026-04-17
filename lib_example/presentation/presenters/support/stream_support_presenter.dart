import 'dart:async';

import '../../../data/models/support/remote_support_model.dart';
import '../../../domain/usecases/event/load_current_event.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/routes/routes.dart';
import '../../../ui/mixins/navigation_data.dart';
import '../../../ui/modules/support/support_presenter.dart';
import '../../../ui/modules/support/support_view_model.dart';
import '../../mixins/mixins.dart';

class StreamSupportPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements SupportPresenter {
  final LoadSupport loadSupport;
  final LoadCurrentEvent loadCurrentEvent;

  StreamSupportPresenter({
    required this.loadSupport,
    required this.loadCurrentEvent,
  });

  final StreamController<SupportViewModel?> _viewModel =
      StreamController<SupportViewModel?>.broadcast();
  @override
  Stream<SupportViewModel?> get viewModel => _viewModel.stream;

  @override
  Future<void> loadData() async {
    try {
      final currentEvent = await loadCurrentEvent.load();
      loadSupport
          .load(
        params: LoadSupportParams(
          eventId: currentEvent?.externalId ?? '',
        ),
      )
          ?.listen(
        (document) async {
          try {
            final model = RemoteSupportModel.fromDocument(document);
            final supportViewModel = await SupportViewModelFactory.make(model);
            _viewModel.add(supportViewModel);
          } catch (e) {
            _viewModel.addError(e);
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
  void goToChatSupport() {
    navigateTo = NavigationData(route: Routes.chatSupport, clear: false);
  }

  @override
  void filterBy(String text, SupportViewModel viewModel) {
    viewModel.filterBy(text);
    _viewModel.add(viewModel);
  }

  @override
  void dispose() {
    _viewModel.close();
  }
}
