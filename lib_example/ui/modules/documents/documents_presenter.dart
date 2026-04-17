import '../../mixins/mixins.dart';
import 'documents_view_model.dart';

abstract class DocumentsPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;
  Stream<DocumentsViewModel?> get viewModel;

  Future<void> loadData();
  void dispose();
  void filterBy(String text, DocumentsViewModel viewModel);
  void selectCurrentFilter({
    required DocumentsFilter? filter,
    required DocumentsViewModel viewModel,
  });
}
