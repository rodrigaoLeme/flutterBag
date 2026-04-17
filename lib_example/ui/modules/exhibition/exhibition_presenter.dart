import '../../../presentation/mixins/loading_manager.dart';
import '../../mixins/mixins.dart';
import 'exhibition_view_model.dart';

abstract class ExhibitionPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;
  Stream<ExhibitionsViewModel?> get exhibitionViewModel;
  Stream<LoadingData?> get isLoadingStream;

  Future<void> loadExhibitions();
  void dispose();
  Future<ExhibitionViewModel> savedFavorites({
    required ExhibitionViewModel exhibitor,
  });
  void setCurrentFilter(ExhibitionGroup filter, ExhibitionsViewModel viewModel);
  void setCurrentDivisionFilter(
      ExhibitionGroup filter, ExhibitionsViewModel viewModel);
  void clearFilter(ExhibitionsViewModel viewModel);
  void filterBy(String text, ExhibitionsViewModel viewModel);
  void showLoadingFlow({required bool loading});
}
