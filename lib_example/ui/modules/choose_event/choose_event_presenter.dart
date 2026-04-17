import '../../../presentation/mixins/loading_manager.dart';
import '../../mixins/mixins.dart';
import 'choose_event_view_model.dart';

abstract class ChooseEventPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<LoadingData?> get isLoadingStream;
  Stream<NavigationData?> get navigateToStream;
  Stream<ChooseEventViewModel?> get viewModel;
  Future<void> loadData();
  void dispose();
  Future<void> selectCurrentEvent(EventViewModel? event);
}
