abstract class SplashPresenter {
  Stream<bool?> get isAuthenticatedStream;
  Future<void> checkSession();
  void dispose();
}

class SplashViewModel {
  final bool? isAuthenticated;
  const SplashViewModel({this.isAuthenticated});
}
