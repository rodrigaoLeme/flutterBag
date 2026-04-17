import '../../../../presentation/mixins/loading_manager.dart';
import '../../../mixins/navigation_data.dart';
import '../spiritual_view_model.dart';

abstract class PrayerRoomPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;
  Stream<PrayerRoomViewModel?> get viewModel;
  Stream<LoadingData?> get isLoadingStream;

  Future<void> convinienceInit();
  void dispose();
}
