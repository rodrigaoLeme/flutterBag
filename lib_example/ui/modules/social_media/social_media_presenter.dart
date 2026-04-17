import '../../mixins/navigation_data.dart';
import 'social_media_view_model.dart';

abstract class SocialMediaPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;
  Stream<SocialMediaViewModel?> get viewModel;

  Future<void> convinienceInit();
  void dispose();
}
