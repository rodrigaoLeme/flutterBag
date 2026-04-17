import '../../../presentation/mixins/loading_manager.dart';
import '../../mixins/mixins.dart';
import 'spiritual_view_model.dart';

abstract class SpiritualPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;
  Stream<SpiritualViewModel?> get viewModel;
  Stream<LoadingData?> get isLoadingStream;

  Future<void> loadData();
  void dispose();
  void goToPrayerRoom({required PrayerRoomViewModel? prayerRoomViewModel});
  void goToMusic({required SpiritualViewModel? spiritualViewModel});
  void goToDevotional({required SpiritualViewModel? spiritualViewModel});
}
