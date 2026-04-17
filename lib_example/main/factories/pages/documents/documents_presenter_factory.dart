import '../../../../presentation/presenters/documents/stream_documents_presenter.dart';
import '../../../../ui/modules/documents/documents_presenter.dart';
import '../../usecases/documents/load_documents_factory.dart';
import '../../usecases/event/load_current_event_factory.dart';

DocumentsPresenter makeDocumentsPresenter() => StreamDocumentsPresenter(
      loadDocuments: makeRemoteLoadDocuments(),
      loadCurrentEvent: makeLocalLoadCurrentEvent(),
    );
