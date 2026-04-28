abstract class SplashPresenter {
  Stream<String?> get navigationRouteStream;
  Stream<bool> get showSecondLogoStream;
  Stream<double> get opacityStream;
  Future<void> checkSession();
  void dispose();
}
