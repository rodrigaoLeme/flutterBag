abstract class ProfilePresenter {
  Stream<String?> get navigationRouteStream;
  Future<void> checkSession();
  void dispose();
}
