import '../../../mixins/navigation_data.dart';
import '../music_view_model.dart';

abstract class MusicPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;
  Stream<MusicListViewModel?> get viewModel;

  Future<void> convinienceInit();
  void dispose();
  void goToMusicDetails({
    required MusicViewModel musicViewModel,
  });
  void filterBy(String text, MusicListViewModel viewModel);
}
