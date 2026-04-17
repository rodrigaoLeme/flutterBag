import '../../../presentation/mixins/loading_manager.dart';
import '../../mixins/mixins.dart';
import 'emergency_view_model.dart';

abstract class EmergencyPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;
  Stream<LoadingData?> get isLoadingStream;
  Stream<EmergencyViewModel?> get viewModel;

  void dispose();
  Future<void> loadData();
}
