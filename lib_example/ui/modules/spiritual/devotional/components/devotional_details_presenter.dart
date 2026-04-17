import '../../../../mixins/navigation_data.dart';
import '../../spiritual_view_model.dart';

abstract class DevotionalDetailsPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;
  Stream<DevotionalsViewModel?> get viewModel;

  Future<void> convinienceInit();
  void dispose();
}
