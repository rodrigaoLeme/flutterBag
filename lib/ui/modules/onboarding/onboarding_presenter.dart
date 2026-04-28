abstract class OnboardingPresenter {
  Stream<bool?> get isAuthenticatedStream;
  Future<void> checkSession();
  void dispose();
}
