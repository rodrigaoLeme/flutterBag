class OnboardingItem {
  final String title;
  final String description;
  final String image;

  const OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
  });
}

abstract class OnboardingPresenter {
  Stream<bool?> get isAuthenticatedStream;
  Stream<int> get currentPageIndexStream;
  Stream<String?> get navigationRouteStream;
  List<OnboardingItem> get items;
  bool isLastPage(int index);
  Future<void> nextPage(int currentIndex);
  Future<void> checkSession();
  Future<void> markTutorialAsSeen();
  void dispose();
}
