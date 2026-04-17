import 'dart:async';

import '../../../data/models/documents/remote_documents_model.dart';
import '../../../domain/usecases/documents/load_documents.dart';
import '../../../domain/usecases/event/load_current_event.dart';
import '../../../ui/modules/documents/documents_presenter.dart';
import '../../../ui/modules/documents/documents_view_model.dart';
import '../../mixins/mixins.dart';

class StreamDocumentsPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements DocumentsPresenter {
  final LoadDocuments loadDocuments;
  final LoadCurrentEvent loadCurrentEvent;

  StreamDocumentsPresenter({
    required this.loadDocuments,
    required this.loadCurrentEvent,
  });

  final StreamController<DocumentsViewModel?> _viewModel =
      StreamController<DocumentsViewModel?>.broadcast();
  @override
  Stream<DocumentsViewModel?> get viewModel => _viewModel.stream;

  @override
  Future<void> loadData() async {
    try {
      isLoading = LoadingData(isLoading: true);

      final currentEvent = await loadCurrentEvent.load();
      loadDocuments
          .load(
              params:
                  LoadDocumentsParams(eventId: currentEvent?.externalId ?? ''))
          ?.listen(
        (document) async {
          try {
            final model = RemoteDocumentsModel.fromDocument(document);
            final documentsViewModel =
                await DocumentsViewModelFactory.make(model);
            _viewModel.add(documentsViewModel);
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

  @override
  void filterBy(String text, DocumentsViewModel viewModel) {
    viewModel.filterBy(text);
    _viewModel.add(viewModel);
  }

  @override
  void selectCurrentFilter({
    required DocumentsFilter? filter,
    required DocumentsViewModel viewModel,
  }) {
    viewModel.setCurrentFilter(filter);
    _viewModel.add(viewModel);
  }
}
