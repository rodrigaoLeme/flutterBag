import '../../../../mixins/navigation_data.dart';
import '../../music_view_model.dart';

abstract class MusicDetailsPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;
  Stream<MusicViewModel?> get viewModel;

  Future<void> convinienceInit();
  void dispose();
}
