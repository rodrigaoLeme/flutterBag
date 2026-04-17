import '../../mixins/mixins.dart';

abstract class ProfilePresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;

  Future<void> loadData();
  void goToEditProfile();
}
