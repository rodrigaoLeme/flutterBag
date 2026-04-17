import '../../mixins/mixins.dart';

abstract class ChatSupportPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;

  Future<void> loadData();
}
