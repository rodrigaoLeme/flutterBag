import '../../mixins/mixins.dart';

abstract class UserIdPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;

  Future<void> loadData();
}
