import '../../mixins/mixins.dart';

abstract class StLouisPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;

  Future<void> loadData();
}
