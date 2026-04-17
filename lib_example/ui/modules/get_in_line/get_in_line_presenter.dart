import '../../mixins/mixins.dart';

abstract class GetInLinePresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;

  Future<void> loadData();
}
