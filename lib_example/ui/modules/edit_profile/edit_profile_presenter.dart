import '../../mixins/mixins.dart';

abstract class EditProfilePresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;

  Future<void> loadData();
}
