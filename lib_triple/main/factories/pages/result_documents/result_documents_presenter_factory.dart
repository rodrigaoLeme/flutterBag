import '../../../../presentation/presenters/result_documents/result_documents_presentation.dart';
import '../../../../ui/modules/result_documents/result_documents_presenter.dart';
import '../../usecases/result_documents/load_result_documents_factory.dart';

ResultDocumentsPresenter makeResultDocumentsPresenter() =>
    ResultDocumentsPresentation(
      loadResultDocuments: makeRemoteLoadResultDocuments(),
    );
