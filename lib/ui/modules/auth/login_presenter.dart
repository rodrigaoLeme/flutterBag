import '../../mixins/navigation_data.dart';

abstract class LoginPresenter {
  Stream<NavigationData?> get navigateToStream;
  Stream<bool> get isSessionExpiredStream;
  Stream<String?> get uiErrorStream;
  Stream<bool?> get isLoadingStream;

  Future<void> auth({
    required String identifier,
    required String password,
  });

  void dispose();
}
