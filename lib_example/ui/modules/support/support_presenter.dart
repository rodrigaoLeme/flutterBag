import '../../mixins/mixins.dart';
import 'support_view_model.dart';

abstract class SupportPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;
  Stream<SupportViewModel?> get viewModel;

  Future<void> loadData();
  void goToChatSupport();
  void dispose();
  void filterBy(String text, SupportViewModel viewModel);
}
